// Loading and error state for the auth screens. AuthGate handles navigation.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/auth/auth_failure.dart';
import '../../../data/repositories/auth/auth_repository.dart';
import '../../../data/repositories/repository_providers.dart';

final authControllerProvider =
    AsyncNotifierProvider.autoDispose<AuthController, void>(AuthController.new);

class AuthController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> signInWithGoogle() => _run((repo) => repo.signInWithGoogle());

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) => _run((repo) => repo.signInWithEmail(email: email, password: password));

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) => _run(
    (repo) =>
        repo.signUpWithEmail(name: name, email: email, password: password),
  );

  Future<bool> sendPasswordReset(String email) =>
      _run((repo) => repo.sendPasswordResetEmail(email));

  Future<bool> resendVerification() =>
      _run((repo) => repo.sendEmailVerification());

  Future<bool> checkVerified() async {
    var verified = false;
    final ok = await _run(
      (repo) async => verified = await repo.reloadAccount(),
    );
    return ok && verified;
  }

  Future<bool> signOut() => _run((repo) => repo.signOut());

  Future<bool> _run(Future<void> Function(AuthRepository repo) action) async {
    final repo = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    try {
      await action(repo);
      // The gate may have closed the screen already, disposing this.
      if (ref.mounted) state = const AsyncData(null);
      return true;
    } catch (error, stack) {
      if (ref.mounted) state = AsyncError(AuthFailure.from(error), stack);
      return false;
    }
  }
}
