// Firestore chats: conversations/{id} with a messages subcollection.
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/conversation_model.dart';
import '../../models/firestore_helpers.dart';
import '../../models/message_model.dart';
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

  @override
  Future<List<ConversationModel>> fetchConversations(String userId) async {
    // Needs the participantIds + updatedAt index in firestore.indexes.json.
    final snapshot = await _conversations
        .where('participantIds', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .get();
    final docs = snapshot.docs;

    final participants = await _users.byIds([
      for (final doc in docs)
        ConversationModel.otherParticipantId(doc.data(), userId),
    ]);

    final listingIds = {
      for (final doc in docs)
        if (doc.data()['listingId'] case final String id) id,
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
      for (final doc in docs)
        ConversationModel.fromFirestore(
          doc.id,
          doc.data(),
          currentUserId: userId,
          participant:
              participants[ConversationModel.otherParticipantId(
                doc.data(),
                userId,
              )] ??
              UserLookup.placeholder(''),
          listing: listings[doc.data()['listingId']],
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
    final conversation = _conversations.doc(conversationId);
    final snapshot = await conversation.get();
    final otherId = ConversationModel.otherParticipantId(
      snapshot.data() ?? const {},
      senderId,
    );
    final message = MessageModel(
      id: '',
      text: text,
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
  }) => _conversations.doc(conversationId).update({
    'unreadCounts.$userId': 0,
  });
}
