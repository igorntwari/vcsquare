// Screen for a single chat conversation.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/conversation_model.dart';
import '../../../data/models/message_model.dart';
import '../../../shared/widgets/avatars/user_avatar.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/listing_preview_chip.dart';
import '../widgets/message_bubble.dart';

// Navy header, the listing being discussed (if any), bubbles and input bar.
// Sent messages are kept locally for now.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.conversation});

  final ConversationModel conversation;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final List<MessageModel> _messages = [...widget.conversation.messages];

  void _send(String text) {
    setState(() {
      _messages.add(
        MessageModel(
          id: 'local_${_messages.length}',
          text: text,
          sentAt: DateTime.now(),
          isMine: true,
          status: MessageStatus.sent,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
              child: ListView.separated(
                reverse: true,
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: _messages.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) => MessageBubble(
                  message: _messages[_messages.length - 1 - index],
                ),
              ),
            ),
            ChatInputBar(onSend: _send),
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
