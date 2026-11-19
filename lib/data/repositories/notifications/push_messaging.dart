// FCM token and topic subscriptions.
import 'package:firebase_messaging/firebase_messaging.dart';

abstract interface class PushMessaging {
  Future<String?> token();

  Stream<String> get tokenRefreshes;

  Future<void> subscribe(String topic);

  Future<void> unsubscribe(String topic);
}

class FirebasePushMessaging implements PushMessaging {
  FirebasePushMessaging([FirebaseMessaging? messaging])
    : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  // register() gives an installation id, not the token Console needs.
  @override
  // ignore: deprecated_member_use
  Future<String?> token() => _messaging.getToken();

  @override
  // ignore: deprecated_member_use
  Stream<String> get tokenRefreshes => _messaging.onTokenRefresh;

  @override
  Future<void> subscribe(String topic) => _messaging.subscribeToTopic(topic);

  @override
  Future<void> unsubscribe(String topic) =>
      _messaging.unsubscribeFromTopic(topic);
}

// Sample mode and tests: records topics, sends nothing.
class SamplePushMessaging implements PushMessaging {
  SamplePushMessaging({this.deviceToken = 'sample-device-token'});

  final String deviceToken;
  final Set<String> topics = {};

  @override
  Future<String?> token() async => deviceToken;

  @override
  Stream<String> get tokenRefreshes => const Stream.empty();

  @override
  Future<void> subscribe(String topic) async => topics.add(topic);

  @override
  Future<void> unsubscribe(String topic) async => topics.remove(topic);
}
