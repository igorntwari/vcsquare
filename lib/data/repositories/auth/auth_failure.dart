// One error type for auth, so screens never show raw Firebase errors.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/constants/app_strings.dart';

enum AuthFailureCode {
  cancelled,
  invalidCredential,
  emailInUse,
  weakPassword,
  invalidEmail,
  userDisabled,
  tooManyRequests,
  network,
  domainNotAllowed,
  differentMethod,
  requiresRecentLogin,
  googleNotConfigured,
  unknown,
}

class AuthFailure implements Exception {
  const AuthFailure(this.code, [this.cause]);

  final AuthFailureCode code;

  final Object? cause;

  factory AuthFailure.from(Object error) => switch (error) {
    AuthFailure() => error,
    FirebaseAuthException(:final code) => AuthFailure(
      _firebaseCodes[code] ?? AuthFailureCode.unknown,
      error,
    ),
    GoogleSignInException(:final code) => AuthFailure(switch (code) {
      GoogleSignInExceptionCode.canceled => AuthFailureCode.cancelled,
      GoogleSignInExceptionCode.clientConfigurationError ||
      GoogleSignInExceptionCode.providerConfigurationError =>
        AuthFailureCode.googleNotConfigured,
      _ => AuthFailureCode.unknown,
    }, error),
    _ => AuthFailure(AuthFailureCode.unknown, error),
  };

  static const Map<String, AuthFailureCode> _firebaseCodes = {
    'invalid-credential': AuthFailureCode.invalidCredential,
    'invalid-login-credentials': AuthFailureCode.invalidCredential,
    'wrong-password': AuthFailureCode.invalidCredential,
    'user-not-found': AuthFailureCode.invalidCredential,
    'email-already-in-use': AuthFailureCode.emailInUse,
    'weak-password': AuthFailureCode.weakPassword,
    'invalid-email': AuthFailureCode.invalidEmail,
    'user-disabled': AuthFailureCode.userDisabled,
    'too-many-requests': AuthFailureCode.tooManyRequests,
    'network-request-failed': AuthFailureCode.network,
    'account-exists-with-different-credential': AuthFailureCode.differentMethod,
    'credential-already-in-use': AuthFailureCode.differentMethod,
    'requires-recent-login': AuthFailureCode.requiresRecentLogin,
  };

  // Null means show nothing. Unknown email and wrong password share a message
  // so the app doesn't reveal which emails are registered.
  String? get message => switch (code) {
    AuthFailureCode.cancelled => null,
    AuthFailureCode.invalidCredential => AppStrings.authInvalidCredential,
    AuthFailureCode.emailInUse => AppStrings.authEmailInUse,
    AuthFailureCode.weakPassword => AppStrings.authWeakPassword,
    AuthFailureCode.invalidEmail => AppStrings.authInvalidEmail,
    AuthFailureCode.userDisabled => AppStrings.authUserDisabled,
    AuthFailureCode.tooManyRequests => AppStrings.authTooManyRequests,
    AuthFailureCode.network => AppStrings.authNetwork,
    AuthFailureCode.domainNotAllowed => AppStrings.authDomainNotAllowed,
    AuthFailureCode.differentMethod => AppStrings.authDifferentMethod,
    AuthFailureCode.requiresRecentLogin => AppStrings.authRequiresRecentLogin,
    AuthFailureCode.googleNotConfigured => AppStrings.authGoogleNotConfigured,
    AuthFailureCode.unknown => AppStrings.authUnknown,
  };

  @override
  String toString() => 'AuthFailure(${code.name}, $cause)';
}
