// Firestore chats: conversations/{id} with a messages subcollection.
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/conversation_model.dart';
import '../../models/firestore_helpers.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../firebase/firestore_collections.dart';
import '../firebase/user_lookup.dart';
import '../listings/firebase_listings_repository.dart';
import 'chats_repository.dart';

class FirebaseChatsRepository implements ChatsRepository {
  FirebaseChatsRepository(this._db)
    : _users = UserLookup(_db),
      _listings = FirebaseListingsRepository(_db);

  final FirebaseFirestore _db;
  final UserLookup _users;
  final FirebaseListingsRepository _listings;

  CollectionReference<Map<String, dynamic>> get _conversations =>
      _db.collection(FirestoreCollections.conversations);

  CollectionReference<Map<String, dynamic>> _messagesOf(String id) =>
      _conversations.doc(id).collection(FirestoreCollections.messages);

  // Needs the participantIds + updatedAt index in firestore.indexes.json.
  Query<Map<String, dynamic>> _inboxQuery(String userId) => _conversations
      .where('participantIds', arrayContains: userId)
      .orderBy('updatedAt', descending: true);

  @override
  Future<List<ConversationModel>> fetchConversations(String userId) async {
    final snapshot = await _inboxQuery(userId).get();
    return _toConversations(snapshot.docs, userId);
  }

  @override
  Stream<List<ConversationModel>> watchConversations(String userId) =>
      _inboxQuery(userId)
          .snapshots()
          .asyncMap((snapshot) => _toConversations(snapshot.docs, userId));

  // Messages are immutable, so "read" is derived: our last message counts
  // as read once the other person's unread count is back to 0.
  Map<String, dynamic> _withReadStatus(Map<String, dynamic> raw, String me) {
    final data = Map<String, dynamic>.from(raw);
    final last = readMap(data['lastMessage']);
    if (last == null || last['senderId'] != me) return data;
    final otherId = ConversationModel.otherParticipantId(data, me);
    final unread = readMap(data['unreadCounts']) ?? const {};
    if (readInt(unread[otherId]) == 0) {
      data['lastMessage'] = {...last, 'status': 'read'};
    }
    return data;
  }

  Future<List<ConversationModel>> _toConversations(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    String userId,
  ) async {
    final rows = [
      for (final doc in docs)
        (id: doc.id, data: _withReadStatus(doc.data(), userId)),
    ];

    final participants = await _users.byIds([
      for (final row in rows)
        ConversationModel.otherParticipantId(row.data, userId),
    ]);

    final listingIds = {
      for (final row in rows)
        if (row.data['listingId'] case final String id) id,
    };
    final listingDocs = await Future.wait([
      for (final id in listingIds)
        _db.collection(FirestoreCollections.listings).doc(id).get(),
    ]);
    final listings = {
      for (final listing in await _listings.toListings(listingDocs))
        listing.id: listing,
    };

    return [
      for (final row in rows)
        ConversationModel.fromFirestore(
          row.id,
          row.data,
          currentUserId: userId,
          participant:
              participants[ConversationModel.otherParticipantId(
                row.data,
                userId,
              )] ??
              UserLookup.placeholder(''),
          listing: listings[row.data['listingId']],
        ),
    ];
  }

  @override
  Stream<List<MessageModel>> watchMessages(String conversationId) =>
      _messagesOf(conversationId)
          .orderBy('sentAt')
          .snapshots()
          .map(
            (snapshot) => [
              for (final doc in snapshot.docs)
                MessageModel.fromFirestore(doc.id, doc.data()),
            ],
          );

  @override
  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    final clean = text.trim();
    if (clean.isEmpty) return;
    final body = clean.length > 2000 ? clean.substring(0, 2000) : clean;

    final conversation = _conversations.doc(conversationId);
    final snapshot = await conversation.get();
    final otherId = ConversationModel.otherParticipantId(
      snapshot.data() ?? const {},
      senderId,
    );
    final message = MessageModel(
      id: '',
      text: body,
      sentAt: DateTime.now(),
      senderId: senderId,
      status: MessageStatus.sent,
    );

    final batch = _db.batch()
      ..set(_messagesOf(conversationId).doc(), message.toFirestore())
      ..update(conversation, {
        'lastMessage': message.toFirestore(),
        'updatedAt': writeDate(message.sentAt),
        if (otherId.isNotEmpty)
          'unreadCounts.$otherId': FieldValue.increment(1),
      });
    await batch.commit();
  }

  @override
  Future<void> markRead({
    required String conversationId,
    required String userId,
  }) => _conversations.doc(conversationId).update({'unreadCounts.$userId': 0});

  @override
  Future<List<UserModel>> fetchPeople(String userId) async {
    final snapshot = await _db
        .collection('users')
        .where('type', isEqualTo: 'student')
        .limit(100)
        .get();
    return [
      for (final doc in snapshot.docs)
        if (doc.id != userId) UserModel.fromFirestore(doc.id, doc.data()),
    ];
  }

  @override
  Future<ConversationModel> openConversation({
    required String userId,
    required UserModel other,
  }) async {
    // Same id for both people, so two taps never create two chats.
    final id = ([userId, other.id]..sort()).join('_');
    final ref = _conversations.doc(id);
    final snapshot = await ref.get();

    final fresh = <String, dynamic>{
      'participantIds': [userId, other.id],
      'type': ConversationType.peer.name,
      'subject': null,
      'listingId': null,
      'lastMessage': <String, dynamic>{},
      'updatedAt': writeDate(DateTime.now()),
      'unreadCounts': {userId: 0, other.id: 0},
      'mutedBy': <String>[],
    };
    if (!snapshot.exists) await ref.set(fresh);

    return ConversationModel.fromFirestore(
      id,
      snapshot.data() ?? fresh,
      currentUserId: userId,
      participant: other,
    );
  }

  @override
  Stream<bool> watchMuted({
    required String conversationId,
    required String userId,
  }) => _conversations.doc(conversationId).snapshots().map((snapshot) {
    final muted = snapshot.data()?['mutedBy'];
    return muted is List && muted.contains(userId);
  });

  @override
  Future<void> setMuted({
    required String conversationId,
    required String userId,
    required bool muted,
  }) => _conversations.doc(conversationId).update({
    'mutedBy': muted
        ? FieldValue.arrayUnion([userId])
        : FieldValue.arrayRemove([userId]),
  });

  @override
  Future<void> blockUser({required String userId, required String blockedId}) =>
      _db.doc('users/$userId/blocks/$blockedId').set({
        'createdAt': writeDate(DateTime.now()),
      });
}
