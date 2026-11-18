// In-memory auth for sample-data mode. Starts signed in as dummyCurrentUser.
import 'dart:async';

import '../../../core/utils/validators.dart';
import '../../dummy/dummy_users.dart';
import '../../models/auth_account_model.dart';
import '../../models/user_model.dart';
import 'auth_failure.dart';
import 'auth_repository.dart';

class SampleAuthRepository implements AuthRepository {
  SampleAuthRepository({bool signedIn = true}) {
    if (signedIn) _current = _accounts[sampleEmail];
  }

  static const String sampleEmail = 'a.kamau@alustudent.com';
  static const String samplePassword = 'campus2026';

  final Map<String, _SampleAccount> _accounts = {
    sampleEmail: _SampleAccount(
      user: dummyCurrentUser,
      email: sampleEmail,
      password: samplePassword,
      method: AuthMethod.password,
      verified: true,
    ),
  };
  _SampleAccount? _current;
  final StreamController<void> _changes = StreamController.broadcast();

  void _emit() => _changes.add(null);

  Stream<T> _watch<T>(T Function() read) async* {
    yield read();
    yield* _changes.stream.map((_) => read());
  }

  @override
  Stream<AuthAccount?> watchAccount() => _watch(() => _current?.account);

  @override
  Stream<UserModel?> watchCurrentUser() => _watch(() => _current?.user);

  @override
  Future<void> signInWithGoogle() async {
    _current = _accounts[sampleEmail]!;
    _emit();
  }

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _requireAluEmail(email);
    final account = _accounts[email.trim().toLowerCase()];
    if (account == null || account.password != password) {
      throw const AuthFailure(AuthFailureCode.invalidCredential);
    }
    _current = account;
    _emit();
  }

  @override
  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    _requireAluEmail(email);
    final key = email.trim().toLowerCase();
    if (_accounts.containsKey(key)) {
      throw const AuthFailure(AuthFailureCode.emailInUse);
    }
    if (Validators.newPassword(password) != null) {
      throw const AuthFailure(AuthFailureCode.weakPassword);
    }
    final account = _SampleAccount(
      user: UserModel(
        id: 'sample_${_accounts.length}',
        name: name.trim(),
        handle: Validators.handleFromEmail(key),
      ),
      email: key,
      password: password,
      method: AuthMethod.password,
      verified: false,
    );
    _accounts[key] = account;
    _current = account;
    _emit();
  }

  @override
  Future<void> sendEmailVerification() async {}

  // No inbox offline, so checking verifies the account.
  @override
  Future<bool> reloadAccount() async {
    final current = _current;
    if (current == null) return false;
    current.verified = true;
    _emit();
    return true;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async =>
      _requireAluEmail(email);

  @override
  Future<void> signOut() async {
    _current = null;
    _emit();
  }

  @override
  Future<void> deleteAccount({String? password}) async {
    final current = _current;
    if (current == null) return;
    if (current.method == AuthMethod.password && current.password != password) {
      throw const AuthFailure(AuthFailureCode.invalidCredential);
    }
    _accounts.remove(current.email);
    _current = null;
    _emit();
  }

  static void _requireAluEmail(String email) {
    if (!Validators.isAllowedEmail(email.trim())) {
      throw const AuthFailure(AuthFailureCode.domainNotAllowed);
    }
  }
}

class _SampleAccount {
  _SampleAccount({
    required this.user,
    required this.email,
    required this.password,
    required this.method,
    required this.verified,
  });

  final UserModel user;
  final String email;
  final String password;
  final AuthMethod method;
  bool verified;

  AuthAccount get account => AuthAccount(
    id: user.id,
    email: email,
    method: method,
    isEmailVerified: verified,
  );
}
