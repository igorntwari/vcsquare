// Loads users by id for the Firebase repositories (post authors, sellers,
// chat participants, community members).
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model.dart';
import 'firestore_collections.dart';

class UserLookup {
  UserLookup(this._db);

  final FirebaseFirestore _db;

  // Firestore allows at most 30 values in a whereIn query.
  static const int _batchSize = 30;

  // Every requested id is in the result. Ids with no users/{id} document map
  // to a placeholder, so a deleted account never breaks a list.
  Future<Map<String, UserModel>> byIds(Iterable<String> ids) async {
    final wanted = ids.where((id) => id.isNotEmpty).toSet().toList();
    final found = <String, UserModel>{};
    for (var i = 0; i < wanted.length; i += _batchSize) {
      final batch = wanted.sublist(
        i,
        i + _batchSize > wanted.length ? wanted.length : i + _batchSize,
      );
      final snapshot = await _db
          .collection(FirestoreCollections.users)
          .where(FieldPath.documentId, whereIn: batch)
          .get();
      for (final doc in snapshot.docs) {
        found[doc.id] = UserModel.fromFirestore(doc.id, doc.data());
      }
    }
    return {for (final id in wanted) id: found[id] ?? placeholder(id)};
  }

  Future<UserModel> byId(String id) async => (await byIds([id]))[id]!;

  static UserModel placeholder(String id) =>
      UserModel(id: id, name: 'Campus member', handle: '');
}

// Reads the ids of every document in users/{userId}/{subcollection}.
Future<Set<String>> readIdSet(
  FirebaseFirestore db,
  String userId,
  String subcollection,
) async {
  final snapshot = await db
      .collection(FirestoreCollections.users)
      .doc(userId)
      .collection(subcollection)
      .get();
  return {for (final doc in snapshot.docs) doc.id};
}

// Adds or removes users/{userId}/{subcollection}/{id}.
Future<void> writeIdFlag(
  FirebaseFirestore db, {
  required String userId,
  required String subcollection,
  required String id,
  required bool value,
}) {
  final ref = db
      .collection(FirestoreCollections.users)
      .doc(userId)
      .collection(subcollection)
      .doc(id);
  return value
      ? ref.set({'createdAt': FieldValue.serverTimestamp()})
      : ref.delete();
}
