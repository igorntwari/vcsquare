// Applies saved topics and stores the device token while signed in.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/notification_service.dart';
import '../../../data/models/auth_account_model.dart';
import '../../../data/models/notification_prefs_model.dart';
import '../../../data/repositories/repository_providers.dart';
import 'notification_prefs_provider.dart';

final pushSyncProvider = NotifierProvider<PushSync, void>(PushSync.new);

class PushSync extends Notifier<void> {
  StreamSubscription<String>? _tokenRefresh;

  @override
  void build() {
    ref.onDispose(() => _tokenRefresh?.cancel());
    ref.listen(
      authAccountProvider,
      (_, next) => _sync(next.value),
      fireImmediately: true,
    );
  }

  Future<void> _sync(AuthAccount? account) async {
    // Read everything up front: the provider can be disposed mid-sync.
    final push = ref.read(pushMessagingProvider);
    final devices = ref.read(deviceRegistryProvider);
    final signedIn = account != null && !account.needsEmailVerification;
    final prefsFuture = signedIn
        ? ref.read(notificationPrefsProvider.future)
        : null;
    await _tokenRefresh?.cancel();
    _tokenRefresh = null;
    try {
      if (prefsFuture == null) {
        for (final topic in NotificationTopic.values) {
          await push.unsubscribe(topic.topic);
        }
        return;
      }
      final prefs = await prefsFuture;
      for (final topic in NotificationTopic.values) {
        prefs.isOn(topic)
            ? await push.subscribe(topic.topic)
            : await push.unsubscribe(topic.topic);
      }
      await NotificationService.instance.setInAppAlerts(prefs.inAppAlerts);

      await devices.register(account!.id);
      if (!ref.mounted) return;
      _tokenRefresh = push.tokenRefreshes.listen(
        (_) => devices.register(account.id),
      );
    } catch (error) {
      // Retried on the next sign-in or launch.
      debugPrint('[Notifications] Sync failed: $error');
    }
  }
}
