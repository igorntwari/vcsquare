// Who is signed in, and signing in and out.
import '../../models/user_model.dart';

abstract interface class AuthRepository {
  // Emits the signed-in user, or null when signed out, and again on change.
  Stream<UserModel?> watchCurrentUser();

  // Throws if the user cancels or sign-in fails.
  Future<UserModel> signInWithGoogle();

  Future<void> signOut();
}
