// Firestore posts: posts/{id}, likes in users/{uid}/likedPosts/{postId}.
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/firestore_helpers.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../firebase/firestore_collections.dart';
import '../firebase/user_lookup.dart';
import 'post_comment.dart';
import 'posts_repository.dart';

class FirebasePostsRepository implements PostsRepository {
  FirebasePostsRepository(this._db) : _users = UserLookup(_db);

  final FirebaseFirestore _db;
  final UserLookup _users;

  static const int _feedLimit = 50;

  CollectionReference<Map<String, dynamic>> get _posts =>
      _db.collection(FirestoreCollections.posts);

  @override
  Future<String> createPost(PostModel post) async {
    final reference = _posts.doc();
    await reference.set(post.toFirestore());
    return reference.id;
  }

  @override
  Future<void> deletePost(String postId) => _posts.doc(postId).delete();

  @override
  Future<List<PostComment>> fetchComments(String postId) async {
    final snapshot = await _posts
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt')
        .get();
    final authors = await _users.byIds([
      for (final doc in snapshot.docs) readString(doc.data()['authorId']),
    ]);
    return [
      for (final doc in snapshot.docs)
        PostComment.fromFirestore(
          doc.id,
          doc.data(),
          author:
              authors[readString(doc.data()['authorId'])] ??
              UserLookup.placeholder(readString(doc.data()['authorId'])),
        ),
    ];
  }

  @override
  Future<void> addComment({
    required String postId,
    required UserModel author,
    required String text,
  }) async {
    final post = _posts.doc(postId);
    final comment = post.collection('comments').doc();
    await _db.runTransaction((transaction) async {
      transaction.set(comment, {
        'authorId': author.id,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      });
      transaction.update(post, {
        'commentCount': FieldValue.increment(1),
        'commentPreview': {'authorId': author.id, 'text': text},
      });
    });
  }

  @override
  Future<List<PostModel>> fetchFeed() async {
    final snapshot = await _posts
        .orderBy('createdAt', descending: true)
        .limit(_feedLimit)
        .get();
    return _toPosts(snapshot.docs);
  }

  @override
  Future<List<PostModel>> fetchPostsByAuthor(String authorId) async {
    final snapshot = await _posts
        .where('authorId', isEqualTo: authorId)
        .orderBy('createdAt', descending: true)
        .get();
    return _toPosts(snapshot.docs);
  }

  @override
  Future<Set<String>> fetchLikedPostIds(String userId) =>
      readIdSet(_db, userId, FirestoreCollections.likedPosts);

  @override
  Future<Set<String>> fetchRsvpedPostIds(String userId) =>
      readIdSet(_db, userId, FirestoreCollections.eventRsvps);

  @override
  Future<Set<String>> fetchSavedPostIds(String userId) =>
      readIdSet(_db, userId, FirestoreCollections.savedPosts);

  @override
  Future<void> setSaved({
    required String userId,
    required String postId,
    required bool saved,
  }) => writeIdFlag(
    _db,
    userId: userId,
    subcollection: FirestoreCollections.savedPosts,
    id: postId,
    value: saved,
  );

  @override
  Future<Map<String, String>> fetchPollVotes(String userId) async {
    final snapshot = await _db
        .collectionGroup(FirestoreCollections.pollVotes)
        .where('userId', isEqualTo: userId)
        .get();
    return {
      for (final doc in snapshot.docs)
        doc.reference.parent.parent!.id: readString(doc.data()['option']),
    };
  }

  @override
  Future<void> setPollVote({
    required String userId,
    required String postId,
    required String option,
  }) => _posts.doc(postId).collection(FirestoreCollections.pollVotes).doc(userId).set({
    'userId': userId,
    'option': option,
    'createdAt': FieldValue.serverTimestamp(),
  });

  @override
  Future<void> setLiked({
    required String userId,
    required String postId,
    required bool liked,
  }) {
    final likeRef = _db
        .collection(FirestoreCollections.users)
        .doc(userId)
        .collection(FirestoreCollections.likedPosts)
        .doc(postId);
    // A transaction so a double tap can't count the same like twice.
    return _db.runTransaction((tx) async {
      final existing = await tx.get(likeRef);
      if (existing.exists == liked) return;
      if (liked) {
        tx.set(likeRef, {'createdAt': FieldValue.serverTimestamp()});
      } else {
        tx.delete(likeRef);
      }
      tx.update(_posts.doc(postId), {
        'likeCount': FieldValue.increment(liked ? 1 : -1),
      });
    });
  }

  @override
  Future<void> setRsvp({
    required String userId,
    required String postId,
    required bool rsvped,
  }) => writeIdFlag(
    _db,
    userId: userId,
    subcollection: FirestoreCollections.eventRsvps,
    id: postId,
    value: rsvped,
  );

  Future<List<PostModel>> _toPosts(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) async {
    final users = await _users.byIds([
      for (final doc in docs) ...[
        readString(doc.data()['authorId']),
        readString(readMap(doc.data()['commentPreview'])?['authorId']),
      ],
    ]);
    return [
      for (final doc in docs)
        PostModel.fromFirestore(
          doc.id,
          doc.data(),
          author:
              users[readString(doc.data()['authorId'])] ??
              UserLookup.placeholder(readString(doc.data()['authorId'])),
          commentAuthor:
              users[readString(
                readMap(doc.data()['commentPreview'])?['authorId'],
              )],
        ),
    ];
  }
}
