// Notification preferences saved on the device.
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:vsquare/data/models/notification_prefs_model.dart';
import 'package:vsquare/data/repositories/notifications/notification_prefs_repository.dart';

void main() {
  group('notification prefs', () {
    setUp(
      () => SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty(),
    );

    test('everything is on until changed', () async {
      expect(
        await NotificationPrefsRepository().load(),
        const NotificationPrefs(),
      );
    });

    test('saved choices are restored by a fresh instance', () async {
      final prefs = const NotificationPrefs()
          .withTopic(NotificationTopic.marketplace, false)
          .withInAppAlerts(false);
      await NotificationPrefsRepository().save(prefs);

      final restored = await NotificationPrefsRepository().load();
      expect(restored.isOn(NotificationTopic.marketplace), isFalse);
      expect(restored.isOn(NotificationTopic.announcements), isTrue);
      expect(restored.inAppAlerts, isFalse);
      expect(restored, prefs);
    });
  });
}
