// Follows in users/{uid}/following. Student follows store targetId too.
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model.dart';
import '../firebase/firestore_collections.dart';
import 'follow_repository.dart';

class FirebaseFollowRepository implements FollowRepository {
  FirebaseFollowRepository(this._db);

  final FirebaseFirestore _db;

  static const int _studentLimit = 50;

  CollectionReference<Map<String, dynamic>> _following(String userId) => _db
      .collection(FirestoreCollections.users)
      .doc(userId)
      .collection(FirestoreCollections.following);

  @override
  Future<List<UserModel>> fetchStudents({required String excludeUserId}) async {
    // Only accounts created through sign-up have createdAt.
    final snapshot = await _db
        .collection(FirestoreCollections.users)
        .orderBy('createdAt', descending: true)
        .limit(_studentLimit)
        .get();
    return [
      for (final doc in snapshot.docs)
        if (doc.id != excludeUserId)
          UserModel.fromFirestore(doc.id, doc.data()),
    ].where((user) => user.isStudent).toList();
  }

  @override
  Stream<Set<String>> watchFollowingIds(String userId) =>
      _following(userId)
          .snapshots()
          .map((snapshot) => {for (final doc in snapshot.docs) doc.id});

  @override
  Future<void> setFollowingStudent({
    required String userId,
    required String studentId,
    required bool following,
  }) {
    final doc = _following(userId).doc(studentId);
    if (!following) return doc.delete();
    return doc.set({
      'targetId': studentId,
      'type': 'user',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<int> watchFollowingCount(String userId) =>
      _following(userId).snapshots().map((snapshot) => snapshot.size);

  @override
  Stream<int> watchFollowerCount(String userId) => _db
      .collectionGroup(FirestoreCollections.following)
      .where('targetId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) => snapshot.size);
}
