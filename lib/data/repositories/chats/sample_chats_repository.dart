// Sample-data chats. Sent messages and read state are kept in memory.
import 'dart:async';

import '../../dummy/dummy_conversations.dart';
import '../../dummy/dummy_messages.dart';
import '../../dummy/dummy_users.dart';
import '../../models/conversation_model.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import 'chats_repository.dart';

class SampleChatsRepository implements ChatsRepository {
  final Map<String, List<MessageModel>> _messages = {
    for (final entry in dummyMessages.entries) entry.key: [...entry.value],
  };
  final Set<String> _readIds = {};
  final Set<String> _mutedIds = {};
  final Set<String> _blockedIds = {};
  final StreamController<String> _changed = StreamController.broadcast();

  // Fires for anything the inbox or menu cares about. Kept apart from
  // _changed so marking a chat read never re-emits its messages.
  final StreamController<String> _inbox = StreamController.broadcast();

  @override
  Future<List<ConversationModel>> fetchConversations(String userId) async => [
    for (final conversation in dummyConversations)
      if (!_blockedIds.contains(conversation.participant.id))
        ConversationModel(
          id: conversation.id,
          participant: conversation.participant,
          type: conversation.type,
          lastMessage:
              _messages[conversation.id]?.last ?? conversation.lastMessage,
          subject: conversation.subject,
          listing: conversation.listing,
          unreadCount: _readIds.contains(conversation.id)
              ? 0
              : conversation.unreadCount,
        ),
  ];

  @override
  Stream<List<ConversationModel>> watchConversations(String userId) async* {
    yield await fetchConversations(userId);
    yield* _inbox.stream.asyncMap((_) => fetchConversations(userId));
  }

  @override
  Stream<List<MessageModel>> watchMessages(String conversationId) async* {
    yield List.of(_messages[conversationId] ?? const []);
    yield* _changed.stream
        .where((id) => id == conversationId)
        .map((_) => List.of(_messages[conversationId] ?? const []));
  }

  @override
  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    final messages = _messages.putIfAbsent(conversationId, () => []);
    messages.add(
      MessageModel(
        id: 'local_${messages.length}',
        text: text,
        sentAt: DateTime.now(),
        senderId: senderId,
        status: MessageStatus.sent,
      ),
    );
    _changed.add(conversationId);
    _inbox.add(conversationId);
  }

  @override
  Future<void> markRead({
    required String conversationId,
    required String userId,
  }) async {
    _readIds.add(conversationId);
    _inbox.add(conversationId);
  }

  @override
  Future<List<UserModel>> fetchPeople(String userId) async => [
    kwameOsei,
    zainabKamara,
    kofiMensah,
    aminaToure,
    jeanLucNiyonzima,
  ];

  @override
  Future<ConversationModel> openConversation({
    required String userId,
    required UserModel other,
  }) async {
    for (final conversation in dummyConversations) {
      if (conversation.participant.id == other.id) return conversation;
    }
    return ConversationModel(
      id: 'new_${other.id}',
      participant: other,
      type: ConversationType.peer,
      lastMessage: MessageModel(
        id: 'last',
        text: '',
        sentAt: DateTime.fromMillisecondsSinceEpoch(0),
        senderId: '',
      ),
    );
  }

  @override
  Stream<bool> watchMuted({
    required String conversationId,
    required String userId,
  }) async* {
    yield _mutedIds.contains(conversationId);
    yield* _inbox.stream
        .where((id) => id == conversationId)
        .map((_) => _mutedIds.contains(conversationId));
  }

  @override
  Future<void> setMuted({
    required String conversationId,
    required String userId,
    required bool muted,
  }) async {
    muted ? _mutedIds.add(conversationId) : _mutedIds.remove(conversationId);
    _inbox.add(conversationId);
  }

  @override
  Future<void> blockUser({
    required String userId,
    required String blockedId,
  }) async {
    _blockedIds.add(blockedId);
    _inbox.add(blockedId);
  }
}
