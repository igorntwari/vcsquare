// Sample-data auth: always signed in as dummyCurrentUser.
import 'dart:async';

import '../../dummy/dummy_users.dart';
import '../../models/user_model.dart';
import 'auth_repository.dart';

class SampleAuthRepository implements AuthRepository {
  UserModel? _user = dummyCurrentUser;
  final StreamController<UserModel?> _changes =
      StreamController<UserModel?>.broadcast();

  @override
  Stream<UserModel?> watchCurrentUser() async* {
    yield _user;
    yield* _changes.stream;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    _user = dummyCurrentUser;
    _changes.add(_user);
    return dummyCurrentUser;
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _changes.add(null);
  }
}
