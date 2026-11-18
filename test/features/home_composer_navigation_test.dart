import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/app/routes/app_router.dart';
import 'package:vsquare/core/constants/app_strings.dart';
import 'package:vsquare/core/theme/app_theme.dart';

import '../helpers/test_app.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('Home composer opens the create-post screen', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          navigatorKey: AppRouter.navigatorKey,
          theme: AppTheme.light,
          routes: AppRouter.routes,
          home: Builder(builder: AppRouter.buildMainShell),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text(AppStrings.composerHint));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text(AppStrings.createPostTitle), findsOneWidget);
  });
}
