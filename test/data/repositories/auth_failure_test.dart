// Mapping Firebase and Google errors to AuthFailure.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vsquare/core/constants/app_strings.dart';
import 'package:vsquare/data/repositories/auth/auth_failure.dart';

AuthFailure _firebase(String code) =>
    AuthFailure.from(FirebaseAuthException(code: code));

void main() {
  test('wrong password and unknown email share one message', () {
    for (final code in [
      'wrong-password',
      'user-not-found',
      'invalid-credential',
    ]) {
      expect(_firebase(code).code, AuthFailureCode.invalidCredential);
      expect(_firebase(code).message, AppStrings.authInvalidCredential);
    }
  });

  test('maps the common Firebase codes', () {
    expect(_firebase('email-already-in-use').code, AuthFailureCode.emailInUse);
    expect(_firebase('weak-password').code, AuthFailureCode.weakPassword);
    expect(
      _firebase('too-many-requests').message,
      AppStrings.authTooManyRequests,
    );
    expect(_firebase('network-request-failed').code, AuthFailureCode.network);
    expect(
      _firebase('requires-recent-login').code,
      AuthFailureCode.requiresRecentLogin,
    );
    expect(
      _firebase('account-exists-with-different-credential').code,
      AuthFailureCode.differentMethod,
    );
  });

  test('unknown codes and other errors fall back to a generic message', () {
    expect(_firebase('something-new').code, AuthFailureCode.unknown);
    expect(_firebase('something-new').message, AppStrings.authUnknown);
    expect(AuthFailure.from(StateError('x')).code, AuthFailureCode.unknown);
  });

  test('closing the Google picker shows nothing', () {
    final failure = AuthFailure.from(
      const GoogleSignInException(code: GoogleSignInExceptionCode.canceled),
    );
    expect(failure.code, AuthFailureCode.cancelled);
    expect(failure.message, isNull);
  });

  test('an AuthFailure passes through unchanged', () {
    const original = AuthFailure(AuthFailureCode.domainNotAllowed);
    expect(AuthFailure.from(original), same(original));
    expect(original.message, AppStrings.authDomainNotAllowed);
  });
}
