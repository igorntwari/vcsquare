// Push setup follows sign-in and sign-out.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:vsquare/data/dummy/dummy_users.dart';
import 'package:vsquare/data/models/notification_prefs_model.dart';
import 'package:vsquare/data/repositories/auth/sample_auth_repository.dart';
import 'package:vsquare/data/repositories/notifications/device_registry.dart';
import 'package:vsquare/data/repositories/notifications/push_messaging.dart';
import 'package:vsquare/data/repositories/repository_providers.dart';
import 'package:vsquare/features/notifications/providers/notification_prefs_provider.dart';
import 'package:vsquare/features/notifications/providers/push_sync_provider.dart';

void main() {
  late SamplePushMessaging push;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    push = SamplePushMessaging();
  });

  group('push sync', () {
    late SampleAuthRepository auth;
    late SampleDeviceRegistry devices;
    late ProviderContainer container;

    setUp(() {
      auth = SampleAuthRepository();
      devices = SampleDeviceRegistry();
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
          pushMessagingProvider.overrideWithValue(push),
          deviceRegistryProvider.overrideWithValue(devices),
        ],
      );
      addTearDown(container.dispose);
    });

    Future<void> settle() => Future<void>.delayed(Duration.zero);

    test('signing in registers the device and applies saved topics', () async {
      await container
          .read(notificationPrefsProvider.notifier)
          .setTopic(NotificationTopic.messages, false);
      container.listen(pushSyncProvider, (_, _) {});
      await container.read(authAccountProvider.future);
      for (var i = 0; i < 5; i++) {
        await settle();
      }

      expect(devices.registered, contains(dummyCurrentUser.id));
      expect(push.topics, containsAll(['announcements', 'marketplace']));
      expect(push.topics, isNot(contains('messages')));

      await auth.signOut();
      for (var i = 0; i < 5; i++) {
        await settle();
      }
      expect(push.topics, isEmpty);
    });
  });
}
