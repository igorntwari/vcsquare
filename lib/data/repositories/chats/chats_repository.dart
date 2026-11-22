// Conversations and their messages.
import '../../models/conversation_model.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';

abstract interface class ChatsRepository {
  // The user's conversations, most recent activity first.
  Future<List<ConversationModel>> fetchConversations(String userId);

  // Same list, but emits again whenever any conversation changes.
  Stream<List<ConversationModel>> watchConversations(String userId);

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

  // Students the user can start a chat with.
  Future<List<UserModel>> fetchPeople(String userId);

  // Finds the 1:1 chat with [other], creating it on first use.
  Future<ConversationModel> openConversation({
    required String userId,
    required UserModel other,
  });

  Stream<bool> watchMuted({
    required String conversationId,
    required String userId,
  });

  Future<void> setMuted({
    required String conversationId,
    required String userId,
    required bool muted,
  });

  Future<void> blockUser({required String userId, required String blockedId});
}
