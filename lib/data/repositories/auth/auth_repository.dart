// Sign-in, sign-out and the account lifecycle. Failures throw AuthFailure.
import '../../models/auth_account_model.dart';
import '../../models/user_model.dart';

abstract interface class AuthRepository {
  // Also emits when the email gets verified (after reloadAccount).
  Stream<AuthAccount?> watchAccount();

  Stream<UserModel?> watchCurrentUser();

  Future<void> signInWithGoogle();

  Future<void> signInWithEmail({
    required String email,
    required String password,
  });

  // Leaves the user signed in but unverified.
  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<void> sendEmailVerification();

  // Returns whether the email is now verified.
  Future<bool> reloadAccount();

  // Succeeds even for unknown emails, so accounts can't be probed.
  Future<void> sendPasswordResetEmail(String email);

  Future<void> signOut();

  // Re-authenticates first: [password] for email, the Google picker otherwise.
  Future<void> deleteAccount({String? password});
}
