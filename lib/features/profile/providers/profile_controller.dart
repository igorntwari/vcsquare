// Save profile, sign out and delete account.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/profile_edit_model.dart';
import '../../../data/repositories/repository_providers.dart';
import 'profile_providers.dart';

final profileControllerProvider =
    AsyncNotifierProvider.autoDispose<ProfileController, void>(
      ProfileController.new,
    );

class ProfileController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> saveProfile(ProfileEdit edit) => _run(() async {
    final userId = await ref.read(currentUserIdProvider.future);
    if (userId == null) return;
    await ref
        .read(profileRepositoryProvider)
        .updateProfile(userId, edit.normalized());
    // The profile page doesn't update live, so reload it.
    ref.invalidate(profileProvider);
  });

  Future<bool> signOut() =>
      _run(() => ref.read(authRepositoryProvider).signOut());

  Future<bool> deleteAccount({String? password}) => _run(
    () => ref.read(authRepositoryProvider).deleteAccount(password: password),
  );

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      // Signing out or deleting may have disposed this already.
      if (ref.mounted) state = const AsyncData(null);
      return true;
    } catch (error, stack) {
      if (ref.mounted) state = AsyncError(error, stack);
      return false;
    }
  }
}
