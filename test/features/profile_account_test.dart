// Edit profile and layout checks.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/core/constants/app_strings.dart';
import 'package:vsquare/data/repositories/profile/sample_profile_repository.dart';
import 'package:vsquare/data/repositories/repository_providers.dart';
import 'package:vsquare/features/profile/screens/edit_profile_screen.dart';

import '../helpers/test_app.dart';

Finder _field(String label) => find.descendant(
  of: find.ancestor(of: find.text(label), matching: find.byType(Column)).first,
  matching: find.byType(TextFormField),
);

void main() {
  setUpAll(loadAppFonts);

  group('edit profile', () {
    testWidgets('is filled in from the profile and saves changes', (
      tester,
    ) async {
      final profiles = SampleProfileRepository();
      var closed = false;
      await pumpScreen(
        tester,
        EditProfileScreen(onDone: () => closed = true),
        overrides: [profileRepositoryProvider.overrideWithValue(profiles)],
      );
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextFormField, 'Amara Kamau'), findsOneWidget);

      await tester.enterText(_field(AppStrings.fullNameLabel), 'Amara K.');
      await tester.enterText(_field(AppStrings.handleLabel), 'Amara.Builds');
      await tester.tap(find.text(AppStrings.save));
      await tester.pumpAndSettle();

      expect(closed, isTrue);
      final saved = await profiles.fetchProfile('any');
      expect(saved.user.name, 'Amara K.');
      expect(saved.user.handle, '@amara.builds');
    });

    testWidgets('blocks invalid input', (tester) async {
      var closed = false;
      await pumpScreen(tester, EditProfileScreen(onDone: () => closed = true));
      await tester.pumpAndSettle();

      await tester.enterText(_field(AppStrings.fullNameLabel), '');
      await tester.enterText(_field(AppStrings.handleLabel), 'No Spaces!');
      await tester.tap(find.text(AppStrings.save));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.nameRequired), findsOneWidget);
      expect(find.text(AppStrings.handleInvalid), findsOneWidget);
      expect(closed, isFalse);
    });

    testWidgets('asks before discarding edits', (tester) async {
      var closed = false;
      await pumpScreen(tester, EditProfileScreen(onDone: () => closed = true));
      await tester.pumpAndSettle();
      await tester.enterText(_field(AppStrings.bioLabel), 'New bio');

      await tester.tap(find.byTooltip(AppStrings.goBack));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.discardChangesTitle), findsOneWidget);

      await tester.tap(find.text(AppStrings.keepEditing));
      await tester.pumpAndSettle();
      expect(closed, isFalse);

      await tester.tap(find.byTooltip(AppStrings.goBack));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.discard));
      await tester.pumpAndSettle();
      expect(closed, isTrue);
    });
  });

  group('layout', () {
    // Any overflow fails the test, so pumping is the check.
    for (final (name, size) in [
      ('landscape', const Size(2340, 1080)),
      ('a small phone', const Size(960, 1600)),
    ]) {
      testWidgets('edit profile fits in $name', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);
        for (final screen in <Widget>[const EditProfileScreen()]) {
          await tester.pumpWidget(
            ProviderScope(child: MaterialApp(home: screen)),
          );
          await tester.pumpAndSettle();
        }
      });
    }
  });
}
