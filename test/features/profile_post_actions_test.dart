// Share and more buttons on the user's own profile posts.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/core/constants/app_strings.dart';
import 'package:vsquare/features/profile/screens/profile_screen.dart';

import '../helpers/test_app.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('share copies the post text', (tester) async {
    final copied = <Object?>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') copied.add(call.arguments);
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await pumpScreen(tester, const ProfileScreen());
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(AppStrings.share).hitTestable().first);
    await tester.pumpAndSettle();
    expect(copied, hasLength(1));
    expect(find.text(AppStrings.postCopied), findsOneWidget);
  });

  testWidgets('more opens copy and delete, and delete asks first', (
    tester,
  ) async {
    await pumpScreen(tester, const ProfileScreen());
    final more = find.byTooltip(AppStrings.moreOptions).first;
    await tester.ensureVisible(more);
    await tester.tap(more);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.copyPostText), findsOneWidget);

    await tester.tap(find.text(AppStrings.deletePost));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.confirmDeletePost), findsOneWidget);
    await tester.tap(find.text(AppStrings.cancel));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });
}
