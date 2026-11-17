// Auth screens through the real routes and gate, on sample data.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/app/routes/app_router.dart';
import 'package:vsquare/app/routes/route_names.dart';
import 'package:vsquare/core/constants/app_strings.dart';
import 'package:vsquare/data/repositories/auth/sample_auth_repository.dart';
import 'package:vsquare/data/repositories/repository_providers.dart';
import 'package:vsquare/features/auth/screens/verify_email_screen.dart';
import 'package:vsquare/features/auth/widgets/terms_agreement.dart';
import 'package:vsquare/shared/widgets/navigation/main_shell.dart';

import '../helpers/test_app.dart';

Future<SampleAuthRepository> _pumpApp(
  WidgetTester tester, {
  bool signedIn = false,
}) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final auth = SampleAuthRepository(signedIn: signedIn);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(auth)],
      child: MaterialApp(
        routes: AppRouter.routes,
        initialRoute: RouteNames.root,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return auth;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _openLogin(WidgetTester tester) =>
    _tap(tester, find.text(AppStrings.getStarted));

Future<void> _fill(WidgetTester tester, String label, String text) async {
  final field = find.ancestor(
    of: find.text(label),
    matching: find.byType(Column),
  );
  await tester.enterText(
    find.descendant(of: field.first, matching: find.byType(TextFormField)),
    text,
  );
}

void main() {
  setUpAll(loadAppFonts);

  testWidgets('signed out: splash, then login', (tester) async {
    await _pumpApp(tester);
    expect(find.text(AppStrings.splashTitle), findsOneWidget);

    await _openLogin(tester);
    expect(find.text(AppStrings.signInTitle), findsOneWidget);
  });

  testWidgets('login validates before calling Firebase', (tester) async {
    await _pumpApp(tester);
    await _openLogin(tester);

    await _tap(tester, find.text(AppStrings.signIn));
    expect(find.text(AppStrings.emailRequired), findsOneWidget);
    expect(find.text(AppStrings.passwordRequired), findsOneWidget);

    await _fill(tester, AppStrings.emailLabel, 'someone@gmail.com');
    await tester.pump();
    expect(find.text(AppStrings.emailNotAlu), findsOneWidget);
  });

  testWidgets('login needs the terms, then shows a friendly error', (
    tester,
  ) async {
    await _pumpApp(tester);
    await _openLogin(tester);
    await _fill(
      tester,
      AppStrings.emailLabel,
      SampleAuthRepository.sampleEmail,
    );
    await _fill(tester, AppStrings.passwordLabel, 'wrong-password1');

    await _tap(tester, find.text(AppStrings.signIn));
    expect(find.text(AppStrings.acceptTermsFirst), findsOneWidget);

    await _tap(tester, find.byType(TermsAgreement));
    await _tap(tester, find.text(AppStrings.signIn));
    expect(find.text(AppStrings.authInvalidCredential), findsOneWidget);
    expect(find.byType(MainShell), findsNothing);
  });

  testWidgets('correct details land on the main tabs', (tester) async {
    await _pumpApp(tester);
    await _openLogin(tester);
    await _fill(
      tester,
      AppStrings.emailLabel,
      SampleAuthRepository.sampleEmail,
    );
    await _fill(
      tester,
      AppStrings.passwordLabel,
      SampleAuthRepository.samplePassword,
    );
    await _tap(tester, find.byType(TermsAgreement));
    await _tap(tester, find.text(AppStrings.signIn));

    expect(find.byType(MainShell), findsOneWidget);
    expect(find.text(AppStrings.signInTitle), findsNothing);
  });

  testWidgets('sign up, verify, then the main tabs', (tester) async {
    await _pumpApp(tester);
    await _openLogin(tester);
    await _tap(tester, find.text(AppStrings.createAccountLink));
    expect(find.text(AppStrings.signUpTitle), findsOneWidget);

    await _fill(tester, AppStrings.fullNameLabel, 'Nadia Uwase');
    await _fill(tester, AppStrings.emailLabel, 'n.uwase@alustudent.com');
    await _fill(tester, AppStrings.passwordLabel, 'campus2026');
    await _fill(tester, AppStrings.confirmPasswordLabel, 'campus2025');
    await _tap(tester, find.text(AppStrings.createAccount));
    expect(find.text(AppStrings.passwordsDontMatch), findsOneWidget);

    await _fill(tester, AppStrings.confirmPasswordLabel, 'campus2026');
    await _tap(tester, find.byType(TermsAgreement));
    await _tap(tester, find.text(AppStrings.createAccount));
    expect(find.byType(VerifyEmailScreen), findsOneWidget);
    expect(find.textContaining('n.uwase@alustudent.com'), findsOneWidget);

    await _tap(tester, find.text(AppStrings.iVerified));
    expect(find.byType(MainShell), findsOneWidget);
  });

  testWidgets('a saved session skips straight to the main tabs', (
    tester,
  ) async {
    final auth = await _pumpApp(tester, signedIn: true);
    expect(find.byType(MainShell), findsOneWidget);

    await auth.signOut();
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.splashTitle), findsOneWidget);
  });

  testWidgets('forgot password confirms without revealing accounts', (
    tester,
  ) async {
    await _pumpApp(tester);
    await _openLogin(tester);
    await _tap(tester, find.text(AppStrings.forgotPassword));
    await _fill(tester, AppStrings.emailLabel, 'anyone@alustudent.com');
    await _tap(tester, find.text(AppStrings.sendResetLink));

    expect(find.text(AppStrings.resetLinkSentTitle), findsOneWidget);
    await _tap(tester, find.text(AppStrings.backToSignIn));
    expect(find.text(AppStrings.signInTitle), findsOneWidget);
  });
}
