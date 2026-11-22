// Notification settings, saved and applied to FCM topics.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/notification_service.dart';
import '../../../data/models/notification_prefs_model.dart';
import '../../../data/repositories/repository_providers.dart';

final notificationPrefsProvider =
    AsyncNotifierProvider<NotificationPrefsController, NotificationPrefs>(
      NotificationPrefsController.new,
    );

class NotificationPrefsController extends AsyncNotifier<NotificationPrefs> {
  @override
  Future<NotificationPrefs> build() =>
      ref.read(notificationPrefsRepositoryProvider).load();

  // Returns false and keeps the old value if it fails.
  Future<bool> setTopic(NotificationTopic topic, bool on) {
    final push = ref.read(pushMessagingProvider);
    return _change(
      (prefs) => prefs.withTopic(topic, on),
      () => on ? push.subscribe(topic.topic) : push.unsubscribe(topic.topic),
    );
  }

  Future<bool> setInAppAlerts(bool on) => _change(
    (prefs) => prefs.withInAppAlerts(on),
    () => NotificationService.instance.setInAppAlerts(on),
  );

  Future<bool> _change(
    NotificationPrefs Function(NotificationPrefs) update,
    Future<void> Function() apply,
  ) async {
    final previous = await future;
    final next = update(previous);
    state = AsyncData(next);
    try {
      await apply();
      await ref.read(notificationPrefsRepositoryProvider).save(next);
      return true;
    } catch (_) {
      if (ref.mounted) state = AsyncData(previous);
      return false;
    }
  }
}
