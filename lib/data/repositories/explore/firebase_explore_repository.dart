// Firestore explore: trendingTopics, officialHandles, communities, and the
// user's following, memberships and peerSuggestions subcollections.
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/community_model.dart';
import '../../models/official_handle_model.dart';
import '../../models/peer_suggestion_model.dart';
import '../../models/trending_topic_model.dart';
import '../firebase/firestore_collections.dart';
import '../firebase/user_lookup.dart';
import 'explore_repository.dart';

class FirebaseExploreRepository implements ExploreRepository {
  FirebaseExploreRepository(this._db) : _users = UserLookup(_db);

  final FirebaseFirestore _db;
  final UserLookup _users;

  @override
  Future<List<TrendingTopicModel>> fetchTrendingTopics() async {
    final snapshot = await _db
        .collection(FirestoreCollections.trendingTopics)
        .orderBy('rank')
        .limit(10)
        .get();
    return [
      for (final doc in snapshot.docs)
        TrendingTopicModel.fromFirestore(doc.data()),
    ];
  }

  @override
  Future<List<OfficialHandleModel>> fetchOfficialHandles() async {
    final snapshot = await _db
        .collection(FirestoreCollections.officialHandles)
        .orderBy('order')
        .get();
    return [
      for (final doc in snapshot.docs)
        OfficialHandleModel.fromFirestore(doc.id, doc.data()),
    ];
  }

  @override
  Future<List<CommunityModel>> fetchCommunities() async {
    final snapshot = await _db
        .collection(FirestoreCollections.communities)
        .orderBy('order')
        .get();
    final members = await _users.byIds([
      for (final doc in snapshot.docs)
        ...CommunityModel.memberPreviewIdsOf(doc.data()),
    ]);
    return [
      for (final doc in snapshot.docs)
        CommunityModel.fromFirestore(
          doc.id,
          doc.data(),
          members: [
            for (final id in CommunityModel.memberPreviewIdsOf(doc.data()))
              ?members[id],
          ],
        ),
    ];
  }

  @override
  Future<List<PeerSuggestionModel>> fetchPeerSuggestions(String userId) async {
    final snapshot = await _db
        .collection(FirestoreCollections.users)
        .doc(userId)
        .collection(FirestoreCollections.peerSuggestions)
        .orderBy('mutualCount', descending: true)
        .limit(10)
        .get();
    final users = await _users.byIds([for (final doc in snapshot.docs) doc.id]);
    return [
      for (final doc in snapshot.docs)
        PeerSuggestionModel.fromFirestore(doc.data(), user: users[doc.id]!),
    ];
  }

  @override
  Future<Set<String>> fetchFollowingIds(String userId) =>
      readIdSet(_db, userId, FirestoreCollections.following);

  @override
  Future<Set<String>> fetchRequestedPeerIds(String userId) async {
    final snapshot = await _db
        .collection(FirestoreCollections.connectionRequests)
        .where('senderId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .get();
    return {for (final doc in snapshot.docs) doc.data()['recipientId'] as String};
  }

  @override
  Future<void> setConnectionRequest({
    required String userId,
    required String peerId,
    required bool requested,
  }) async {
    final request = _db
        .collection(FirestoreCollections.connectionRequests)
        .doc('${userId}_$peerId');
    if (!requested) {
      await request.delete();
      return;
    }
    await request.set({
      'senderId': userId,
      'recipientId': peerId,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> setFollowing({
    required String userId,
    required String targetId,
    required bool following,
  }) => writeIdFlag(
    _db,
    userId: userId,
    subcollection: FirestoreCollections.following,
    id: targetId,
    value: following,
  );

  @override
  Future<Set<String>> fetchJoinedIds(String userId) =>
      readIdSet(_db, userId, FirestoreCollections.memberships);

  @override
  Future<void> setJoined({
    required String userId,
    required String groupId,
    required bool joined,
  }) => writeIdFlag(
    _db,
    userId: userId,
    subcollection: FirestoreCollections.memberships,
    id: groupId,
    value: joined,
  );
}
