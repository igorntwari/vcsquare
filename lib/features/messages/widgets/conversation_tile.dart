// Row summarising a conversation in the inbox.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/conversation_model.dart';
import '../../../data/models/message_model.dart';
import '../../../shared/widgets/avatars/user_avatar.dart';
import '../../../shared/widgets/chips/status_tag.dart';
import 'listing_preview_chip.dart';

// White card: avatar, name and tag, time, optional subject, last message,
// attached listing, and an unread count or read receipt on the right.
class ConversationTile extends StatelessWidget {
  const ConversationTile({
    super.key,
    required this.conversation,
    required this.unreadCount,
    this.onTap,
  });

  final ConversationModel conversation;

  // Passed in so the inbox can clear it once the chat has been opened.
  final int unreadCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final participant = conversation.participant;
    final last = conversation.lastMessage;
    final isUnread = unreadCount > 0;

    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        boxShadow: AppShadows.card,
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatar(),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    participant.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.titleLarge.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                ?_buildTag(),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            Formatters.chatTimestamp(last.sentAt),
                            style: AppTypography.bodySmall.copyWith(
                              color: isUnread
                                  ? AppColors.accent
                                  : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      if (conversation.subject != null) ...[
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          conversation.subject!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.label.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xxs),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              last.isMine
                                  ? '${AppStrings.you} ${last.text}'
                                  : last.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  (isUnread
                                          ? AppTypography.bodyLargeStrong
                                          : AppTypography.bodyMedium)
                                      .copyWith(
                                        color: isUnread
                                            ? AppColors.textPrimary
                                            : AppColors.textMuted,
                                      ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          ?_buildTrailingStatus(last, unreadCount),
                        ],
                      ),
                      if (conversation.listing != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        ListingPreviewChip(listing: conversation.listing!),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Students: photo with an online dot. Offices and clubs: navy crest with a
  // green verified tick.
  Widget _buildAvatar() {
    final participant = conversation.participant;
    final Widget avatar;
    final Widget? badge;
    if (participant.isStudent) {
      avatar = UserAvatar(
        size: AppSizes.avatarXl,
        imagePath: participant.avatarPath,
      );
      badge = participant.isOnline ? _buildStatusDot() : null;
    } else {
      avatar = Container(
        width: AppSizes.avatarXl,
        height: AppSizes.avatarXl,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(
          participant.isOfficial ? Icons.school : Icons.groups,
          size: AppSizes.iconMd,
          color: AppColors.textOnDark,
        ),
      );
      badge = _buildStatusDot(icon: Icons.check);
    }
    return Stack(
      children: [
        avatar,
        if (badge != null) Positioned(right: 0, bottom: 0, child: badge),
      ],
    );
  }

  Widget _buildStatusDot({IconData? icon}) {
    return Container(
      width: AppSizes.avatarStatusDot,
      height: AppSizes.avatarStatusDot,
      decoration: BoxDecoration(
        color: AppColors.online,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.surface,
          width: AppSizes.borderThick,
        ),
      ),
      child: icon == null
          ? null
          : Icon(icon, size: AppSizes.activityDot, color: AppColors.textOnDark),
    );
  }

  Widget? _buildTag() {
    final participant = conversation.participant;
    final StatusTag? tag;
    if (participant.isOfficial) {
      tag = const StatusTag(
        label: AppStrings.official,
        icon: Icons.verified,
        backgroundColor: AppColors.greenSurface,
        foregroundColor: AppColors.success,
      );
    } else if (participant.isClub) {
      tag = const StatusTag(
        label: AppStrings.clubHub,
        backgroundColor: AppColors.chipBackground,
        foregroundColor: AppColors.textSecondary,
      );
    } else if (participant.cohort != null) {
      tag = StatusTag(
        label: participant.cohort!,
        backgroundColor: AppColors.blueSurface,
        foregroundColor: AppColors.textPrimary,
      );
    } else {
      tag = null;
    }
    if (tag == null) return null;
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs),
      child: tag,
    );
  }

  // Unread count bubble, or ticks when the last message was ours.
  Widget? _buildTrailingStatus(MessageModel last, int unread) {
    if (unread > 0) {
      return Semantics(
        label: AppStrings.unreadMessages(unread),
        child: Container(
          width: AppSizes.unreadBadge,
          height: AppSizes.unreadBadge,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
            boxShadow: AppShadows.card,
          ),
          child: Text(
            '$unread',
            style: AppTypography.caption.copyWith(color: AppColors.textOnDark),
          ),
        ),
      );
    }
    if (!last.isMine) return null;
    final isRead = last.status == MessageStatus.read;
    return Icon(
      isRead ? Icons.done_all : Icons.check,
      size: AppSizes.iconSm,
      color: isRead ? AppColors.readReceipt : AppColors.iconMuted,
    );
  }
}
