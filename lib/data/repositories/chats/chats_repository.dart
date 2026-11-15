// Conversations and their messages.
//
// Not wired into the Messages screens yet: that feature is owned
// separately. The screens still read lib/data/dummy directly.
import '../../models/conversation_model.dart';
import '../../models/message_model.dart';

abstract interface class ChatsRepository {
  // The user's conversations, most recent activity first.
  Future<List<ConversationModel>> fetchConversations(String userId);

  // Oldest first. Emits again whenever a message is added.
  Stream<List<MessageModel>> watchMessages(String conversationId);

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  });

  // Clears the user's unread count for the conversation.
  Future<void> markRead({
    required String conversationId,
    required String userId,
  });
}
