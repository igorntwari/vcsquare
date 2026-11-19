// Students following students, and live follower/following counts.
import '../../models/user_model.dart';

abstract interface class FollowRepository {
  // Newest students first, without [excludeUserId].
  Future<List<UserModel>> fetchStudents({required String excludeUserId});

  // Ids in users/{userId}/following: students and official handles.
  Stream<Set<String>> watchFollowingIds(String userId);

  Future<void> setFollowingStudent({
    required String userId,
    required String studentId,
    required bool following,
  });

  Stream<int> watchFollowingCount(String userId);

  Stream<int> watchFollowerCount(String userId);
}
