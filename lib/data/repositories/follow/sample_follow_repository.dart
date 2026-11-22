// Sample-data follows, kept in memory.
import 'dart:async';

import '../../dummy/dummy_users.dart';
import '../../models/user_model.dart';
import 'follow_repository.dart';

class SampleFollowRepository implements FollowRepository {
  // follower id -> ids they follow
  final Map<String, Set<String>> _following = {};
  final StreamController<void> _changes = StreamController.broadcast();

  Stream<T> _watch<T>(T Function() read) async* {
    yield read();
    yield* _changes.stream.map((_) => read());
  }

  @override
  Future<List<UserModel>> fetchStudents({
    required String excludeUserId,
  }) async => [
    for (final user in dummyUsers)
      if (user.isStudent && user.id != excludeUserId) user,
  ];

  @override
  Stream<Set<String>> watchFollowingIds(String userId) =>
      _watch(() => {...?_following[userId]});

  @override
  Future<void> setFollowingStudent({
    required String userId,
    required String studentId,
    required bool following,
  }) async {
    final ids = _following.putIfAbsent(userId, () => {});
    following ? ids.add(studentId) : ids.remove(studentId);
    _changes.add(null);
  }

  @override
  Stream<int> watchFollowingCount(String userId) =>
      _watch(() => _following[userId]?.length ?? 0);

  @override
  Stream<int> watchFollowerCount(String userId) => _watch(
    () => _following.values.where((ids) => ids.contains(userId)).length,
  );
}
