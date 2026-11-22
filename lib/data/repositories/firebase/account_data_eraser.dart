// Deletes a user's Firestore data. Runs before the Auth account is deleted.
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_collections.dart';

class AccountDataEraser {
  AccountDataEraser(this._db);

  final FirebaseFirestore _db;

  // Firestore's limit is 500 writes per batch.
  static const int _batchLimit = 450;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection(FirestoreCollections.users).doc(uid);

  Future<void> erase(String uid) async {
    await _unlikePosts(uid);
    final refs = <DocumentReference<Map<String, dynamic>>>[
      ...await _docsIn(uid, FirestoreCollections.likedPosts),
      ...await _docsIn(uid, FirestoreCollections.savedListings),
      ...await _docsIn(uid, FirestoreCollections.memberships),
      ...await _docsIn(uid, FirestoreCollections.following),
      ...await _docsIn(uid, FirestoreCollections.peerSuggestions),
      ...await _docsIn(uid, FirestoreCollections.devices),
      ...await _docsIn(uid, FirestoreCollections.listingDrafts),
      ...await _owned(FirestoreCollections.posts, 'authorId', uid),
      ...await _owned(FirestoreCollections.listings, 'sellerId', uid),
      _userDoc(uid),
    ];
    await _deleteAll(refs);
    // Conversations are kept for the other participant.
  }

  Future<void> _unlikePosts(String uid) async {
    final liked = await _docsIn(uid, FirestoreCollections.likedPosts);
    for (final like in liked) {
      final post = _db.collection(FirestoreCollections.posts).doc(like.id);
      if (!(await post.get()).exists) continue;
      await post.update({'likeCount': FieldValue.increment(-1)});
    }
  }

  Future<List<DocumentReference<Map<String, dynamic>>>> _docsIn(
    String uid,
    String subcollection,
  ) async {
    final snapshot = await _userDoc(uid).collection(subcollection).get();
    return [for (final doc in snapshot.docs) doc.reference];
  }

  Future<List<DocumentReference<Map<String, dynamic>>>> _owned(
    String collection,
    String ownerField,
    String uid,
  ) async {
    final snapshot = await _db
        .collection(collection)
        .where(ownerField, isEqualTo: uid)
        .get();
    return [for (final doc in snapshot.docs) doc.reference];
  }

  Future<void> _deleteAll(
    List<DocumentReference<Map<String, dynamic>>> refs,
  ) async {
    for (var i = 0; i < refs.length; i += _batchLimit) {
      final end = i + _batchLimit > refs.length ? refs.length : i + _batchLimit;
      final batch = _db.batch();
      for (final ref in refs.sublist(i, end)) {
        batch.delete(ref);
      }
      await batch.commit();
    }
  }
}
