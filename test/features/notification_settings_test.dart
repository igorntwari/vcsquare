// Notification settings screen.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:vsquare/core/constants/app_strings.dart';
import 'package:vsquare/core/services/notification_service.dart';
import 'package:vsquare/data/repositories/notifications/push_messaging.dart';
import 'package:vsquare/data/repositories/repository_providers.dart';
import 'package:vsquare/features/notifications/screens/notification_settings_screen.dart';

import '../helpers/test_app.dart';

Finder _switchFor(String title) => find.descendant(
  of: find.widgetWithText(SwitchListTile, title),
  matching: find.byType(Switch),
);

void main() {
  setUpAll(loadAppFonts);

  late SamplePushMessaging push;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    push = SamplePushMessaging();
    NotificationService.instance.permissionGranted.value = null;
  });

  group('settings', () {
    testWidgets('a turned-off topic unsubscribes and survives a restart', (
      tester,
    ) async {
      final overrides = [pushMessagingProvider.overrideWithValue(push)];
      await pumpScreen(
        tester,
        const NotificationSettingsScreen(),
        overrides: overrides,
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<Switch>(_switchFor(AppStrings.topicMarketplace)).value,
        isTrue,
      );

      await tester.tap(_switchFor(AppStrings.topicMarketplace));
      await tester.pumpAndSettle();
      expect(push.topics, isNot(contains('marketplace')));

      // A fresh ProviderScope reads the saved value back, like a relaunch.
      await tester.pumpWidget(const SizedBox());
      await pumpScreen(
        tester,
        const NotificationSettingsScreen(),
        overrides: overrides,
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<Switch>(_switchFor(AppStrings.topicMarketplace)).value,
        isFalse,
      );
      expect(
        tester.widget<Switch>(_switchFor(AppStrings.topicAnnouncements)).value,
        isTrue,
      );
    });

    testWidgets('warns when notifications are blocked', (tester) async {
      NotificationService.instance.permissionGranted.value = false;
      await pumpScreen(tester, const NotificationSettingsScreen());
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.notificationsOffTitle), findsOneWidget);
    });
  });
}
