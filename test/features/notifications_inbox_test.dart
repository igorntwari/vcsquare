// The notifications inbox.
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/core/constants/app_strings.dart';
import 'package:vsquare/core/services/notification_service.dart';
import 'package:vsquare/data/models/notification_model.dart';
import 'package:vsquare/features/notifications/screens/notifications_screen.dart';

import '../helpers/test_app.dart';

NotificationModel _notification(String id, {Map<String, String>? data}) =>
    NotificationModel(
      id: id,
      title: 'Title $id',
      body: 'Body $id',
      receivedAt: DateTime(2026, 11, 18),
      data: data ?? const {},
    );

void main() {
  setUpAll(loadAppFonts);

  setUp(() {
    NotificationService.instance.notifications.value = const [];
    NotificationService.instance.permissionGranted.value = null;
  });

  group('inbox', () {
    testWidgets('a notification with a screen opens it', (tester) async {
      NotificationService.instance.notifications.value = [
        _notification('a', data: {'screen': 'market'}),
        _notification('b'),
      ];
      NotificationModel? opened;
      await pumpScreen(tester, NotificationsScreen(onOpen: (n) => opened = n));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Title b'));
      await tester.pumpAndSettle();
      expect(opened, isNull);

      await tester.tap(find.text('Title a'));
      await tester.pumpAndSettle();
      expect(opened?.id, 'a');
    });
  });

  testWidgets('warns when notifications are blocked', (tester) async {
    NotificationService.instance.permissionGranted.value = false;
    await pumpScreen(tester, const NotificationsScreen());
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.notificationsOffTitle), findsOneWidget);
  });
}
