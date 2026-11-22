
// Riverpod glue for the Messages screens.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/dummy/dummy_users.dart';
import '../../../data/models/conversation_model.dart';
import '../../../data/models/message_model.dart';
import '../../../data/repositories/repository_providers.dart';

String currentChatUserId() {
  try {
    return FirebaseAuth.instance.currentUser?.uid ?? dummyCurrentUser.id;
  } catch (_) {
    return dummyCurrentUser.id;
  }
}

final conversationsProvider =
    StreamProvider.autoDispose<List<ConversationModel>>(
  (ref) => ref
      .watch(chatsRepositoryProvider)
      .watchConversations(currentChatUserId()),
);

final messagesProvider = StreamProvider.autoDispose
    .family<List<MessageModel>, String>(
  (ref, id) => ref
      .watch(chatsRepositoryProvider)
      .watchMessages(id),
);

final mutedProvider = StreamProvider.autoDispose.family<bool, String>(
  (ref, id) => ref
      .watch(chatsRepositoryProvider)
      .watchMuted(
        conversationId: id,
        userId: currentChatUserId(),
      ),
);

