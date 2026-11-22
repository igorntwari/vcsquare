// Screen for a single chat conversation.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/conversation_model.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../shared/widgets/feedback/error_state.dart';
import '../../../shared/widgets/avatars/user_avatar.dart';
import '../providers/chats_providers.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/listing_preview_chip.dart';
import '../widgets/message_bubble.dart';

// Navy header, the listing being discussed (if any), live messages and input.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.conversation});

  final ConversationModel conversation;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  bool _isSending = false;
  String? _readMarkedForUser;

  Future<void> _markRead(String userId) async {
    if (_readMarkedForUser == userId) return;
    _readMarkedForUser = userId;
    try {
      await ref
          .read(chatsRepositoryProvider)
          .markRead(conversationId: widget.conversation.id, userId: userId);
    } catch (_) {
      _readMarkedForUser = null;
      _showError(AppStrings.saveFailed);
    }
  }

  Future<void> _send(String text, String? userId) async {
    if (userId == null || _isSending) return;
    setState(() => _isSending = true);
    try {
      await ref
          .read(chatsRepositoryProvider)
          .sendMessage(
            conversationId: widget.conversation.id,
            senderId: userId,
            text: text,
          );
    } catch (_) {
      _showError(AppStrings.sendFailed);
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(currentUserProvider).value?.id;
    final messages = ref.watch(messagesProvider(widget.conversation.id));
    if (userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _markRead(userId));
    }
    final listing = widget.conversation.listing;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            _buildHeader(context),
            if (listing != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  0,
                ),
                child: ListingPreviewChip(
                  listing: listing,
                  backgroundColor: AppColors.surface,
                  onView: () {},
                ),
              ),
            Expanded(
              // Reversed so the newest message sits just above the input bar.
              child: messages.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => ErrorState(
                  onRetry: () =>
                      ref.invalidate(messagesProvider(widget.conversation.id)),
                ),
                data: (items) => ListView.separated(
                  reverse: true,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final message = items[items.length - 1 - index];
                    return MessageBubble(
                      message: message,
                      isMine: userId != null && message.isFrom(userId),
                    );
                  },
                ),
              ),
            ),
            IgnorePointer(
              ignoring: _isSending || userId == null,
              child: Opacity(
                opacity: _isSending || userId == null ? 0.6 : 1,
                child: ChatInputBar(onSend: (text) => _send(text, userId)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final participant = widget.conversation.participant;
    final subtitle = participant.isOnline
        ? AppStrings.online
        : participant.handle;

    return ColoredBox(
      color: AppColors.topBarBackground,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: AppSizes.topBarHeight,
          child: Row(
            children: [
              IconButton(
                tooltip: AppStrings.back,
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(
                  Icons.arrow_back,
                  size: AppSizes.iconLg,
                  color: AppColors.textOnDark,
                ),
              ),
              participant.isStudent
                  ? UserAvatar(
                      size: AppSizes.avatarMd,
                      imagePath: participant.avatarPath,
                    )
                  : Container(
                      width: AppSizes.avatarMd,
                      height: AppSizes.avatarMd,
                      decoration: const BoxDecoration(
                        color: AppColors.iconCircleOnDark,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        participant.isOfficial ? Icons.school : Icons.groups,
                        size: AppSizes.iconMd,
                        color: AppColors.textOnDark,
                      ),
                    ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      participant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.textOnDark,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: participant.isOnline
                            ? AppColors.online
                            : AppColors.textOnDarkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: AppStrings.moreOptions,
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert,
                  size: AppSizes.iconLg,
                  color: AppColors.textOnDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
