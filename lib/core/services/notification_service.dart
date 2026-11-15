// Push notifications (Firebase Cloud Messaging) and the in-app inbox.
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/notification_model.dart';

const String _storageKey = 'notifications_inbox';
const int _maxStored = 100;

// Every device subscribes to this topic, so a Firebase Console campaign
// targeting topic "all" reaches everyone.
const String broadcastTopic = 'all';

// Runs in its own isolate when a push arrives while the app is in the
// background or closed. Android shows the system notification itself; this
// only saves it to the inbox.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService._saveToStore(NotificationService._toModel(message));
}

class NotificationService with WidgetsBindingObserver {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  // Matches default_notification_channel_id in AndroidManifest.xml.
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'vsquare_general',
    'General',
    description: 'Campus announcements, messages and activity.',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  // Newest first. Widgets listen to this to show the list and unread dot.
  final ValueNotifier<List<NotificationModel>> notifications = ValueNotifier(
    const [],
  );

  VoidCallback? _openInboxHandler;
  bool _openInboxPending = false;

  int get unreadCount => notifications.value.where((n) => !n.isRead).length;

  // Call once in main() after Firebase.initializeApp and before runApp.
  Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await _reload();
    WidgetsBinding.instance.addObserver(this);

    await _local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (_) => _requestOpenInbox(),
    );
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    final messaging = FirebaseMessaging.instance;
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // App open: FCM does not show anything on Android, so show it ourselves.
    FirebaseMessaging.onMessage.listen((message) async {
      final model = _toModel(message);
      await _add(model);
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _showLocal(model);
      }
    });

    // App in background and the user taps the notification.
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await _add(_toModel(message));
      _requestOpenInbox();
    });

    // App was closed and launched by tapping a notification.
    final initial = await messaging.getInitialMessage();
    if (initial != null) {
      await _add(_toModel(initial));
      _requestOpenInbox();
    } else {
      final launch = await _local.getNotificationAppLaunchDetails();
      if (launch?.didNotificationLaunchApp ?? false) _requestOpenInbox();
    }

    messaging.onTokenRefresh.listen(_logToken);
  }

  // Asks for permission (Android 13+ and iOS), subscribes to the broadcast
  // topic and prints this device's token. Safe to call on every launch.
  Future<void> requestPermissionAndSubscribe() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('[Notifications] Permission denied by the user.');
      return;
    }
    try {
      await messaging.subscribeToTopic(broadcastTopic);
      _logToken(await messaging.getToken());
    } catch (error) {
      // Usually no network or no Google Play services on the emulator.
      debugPrint('[Notifications] Could not register for push: $error');
    }
  }

  // The app layer decides how the inbox is opened (see AppRouter).
  void setOpenInboxHandler(VoidCallback handler) {
    _openInboxHandler = handler;
    if (_openInboxPending) {
      _openInboxPending = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => handler());
    }
  }

  void openInbox() => _requestOpenInbox();

  Future<void> markRead(String id) => _update(
    notifications.value
        .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
        .toList(),
  );

  Future<void> markAllRead() => _update(
    notifications.value.map((n) => n.copyWith(isRead: true)).toList(),
  );

  Future<void> remove(String id) =>
      _update(notifications.value.where((n) => n.id != id).toList());

  // Pick up pushes the background isolate saved while the app was away.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _reload();
  }

  void _requestOpenInbox() {
    final handler = _openInboxHandler;
    if (handler == null) {
      _openInboxPending = true;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => handler());
      WidgetsBinding.instance.scheduleFrame();
    }
  }

  void _logToken(String? token) {
    // Paste this into Firebase Console -> Messaging -> "Send test message".
    debugPrint('[Notifications] FCM token: $token');
  }

  Future<void> _showLocal(NotificationModel model) => _local.show(
    id: model.id.hashCode & 0x7fffffff,
    title: model.title,
    body: model.body,
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
    payload: model.id,
  );

  Future<void> _add(NotificationModel model) async {
    await _saveToStore(model);
    await _reload();
  }

  Future<void> _reload() async => notifications.value = await _readStore();

  Future<void> _update(List<NotificationModel> next) async {
    notifications.value = next;
    await _writeStore(next);
  }

  static NotificationModel _toModel(RemoteMessage message) {
    final notification = message.notification;
    final data = message.data.map((key, value) => MapEntry(key, '$value'));
    return NotificationModel(
      id:
          message.messageId ??
          '${message.sentTime?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch}',
      title: notification?.title ?? data['title'] ?? '',
      body: notification?.body ?? data['body'] ?? '',
      receivedAt: message.sentTime ?? DateTime.now(),
      data: data,
    );
  }

  // Storage helpers are static so the background isolate can use them.
  // SharedPreferencesAsync has no in-memory cache, so both isolates always
  // see the latest saved list.
  static Future<List<NotificationModel>> _readStore() async {
    final raw = await SharedPreferencesAsync().getString(_storageKey);
    if (raw == null) return const [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  static Future<void> _writeStore(List<NotificationModel> list) =>
      SharedPreferencesAsync().setString(
        _storageKey,
        jsonEncode(list.take(_maxStored).map((n) => n.toJson()).toList()),
      );

  static Future<void> _saveToStore(NotificationModel model) async {
    final current = await _readStore();
    if (current.any((n) => n.id == model.id)) return;
    await _writeStore([model, ...current]);
  }
}
