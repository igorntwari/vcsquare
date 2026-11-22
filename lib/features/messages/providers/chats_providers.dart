// Riverpod glue for the Messages screens.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/conversation_model.dart';
import '../../../data/models/message_model.dart';
import '../../../data/repositories/repository_providers.dart';

final conversationsProvider =
    StreamProvider.autoDispose<List<ConversationModel>>((ref) async* {
      final userId = await ref.watch(currentUserIdProvider.future);
      if (userId == null) {
        yield const [];
        return;
      }
      yield* ref.watch(chatsRepositoryProvider).watchConversations(userId);
    });

final messagesProvider = StreamProvider.autoDispose
    .family<List<MessageModel>, String>(
      (ref, id) => ref.watch(chatsRepositoryProvider).watchMessages(id),
    );

final mutedProvider = StreamProvider.autoDispose.family<bool, String>((
  ref,
  id,
) async* {
  final userId = await ref.watch(currentUserIdProvider.future);
  if (userId == null) {
    yield false;
    return;
  }
  yield* ref
      .watch(chatsRepositoryProvider)
      .watchMuted(conversationId: id, userId: userId);
});
