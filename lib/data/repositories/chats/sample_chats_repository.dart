// Sample-data chats. Sent messages and read state are kept in memory.
import 'dart:async';

import '../../dummy/dummy_conversations.dart';
import '../../dummy/dummy_messages.dart';
import '../../models/conversation_model.dart';
import '../../models/message_model.dart';
import 'chats_repository.dart';

class SampleChatsRepository implements ChatsRepository {
  final Map<String, List<MessageModel>> _messages = {
    for (final entry in dummyMessages.entries) entry.key: [...entry.value],
  };
  final Set<String> _readIds = {};
  final StreamController<String> _changed = StreamController.broadcast();

  @override
  Future<List<ConversationModel>> fetchConversations(String userId) async => [
    for (final conversation in dummyConversations)
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
  }

  @override
  Future<void> markRead({
    required String conversationId,
    required String userId,
  }) async {
    _readIds.add(conversationId);
  }
}
