// Card for a pinned official announcement.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/post_model.dart';
import '../../../shared/widgets/cards/app_card.dart';
import '../../../shared/widgets/chips/status_tag.dart';
import 'post_actions_row.dart';
import 'post_author_header.dart';
import 'post_body_text.dart';

// Pinned post with a gradient accent strip and an optional RSVP callout.
class PinnedAnnouncementCard extends StatelessWidget {
  const PinnedAnnouncementCard({
    super.key,
    required this.post,
    required this.isLiked,
    required this.likeCount,
    this.onLike,
  });

  final PostModel post;
  final bool isLiked;
  final int likeCount;
  final VoidCallback? onLike;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: AppSizes.accentStrip,
            decoration: const BoxDecoration(
              gradient: AppColors.announcementStripGradient,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.push_pin,
                      size: AppSizes.iconXs,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        AppStrings.pinnedAnnouncement,
                        style: AppTypography.overline.copyWith(
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                    if (post.topic != null)
                      StatusTag(
                        label: post.topic!,
                        icon: Icons.event_note_outlined,
                        backgroundColor: AppColors.surfaceMuted,
                        foregroundColor: AppColors.textMuted,
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                PostAuthorHeader(
                  author: post.author,
                  timeAgo: Formatters.timeAgo(post.createdAt),
                ),
                const SizedBox(height: AppSpacing.sm),
                PostBodyText(title: post.title, body: post.body),
                if (post.event != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  _buildCallout(post.event!),
                ],
                PostActionsRow(
                  likeCount: likeCount,
                  commentCount: post.commentCount,
                  isLiked: isLiked,
                  onLike: onLike,
                  trailing: post.isMandatoryRead
                      ? const StatusTag(
                          label: AppStrings.mandatoryRead,
                          icon: Icons.done_all,
                          backgroundColor: AppColors.greenSurface,
                          foregroundColor: AppColors.success,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Compact event row: icon, title and date, and an RSVP button.
  Widget _buildCallout(EventModel event) {
    final when =
        '${Formatters.monthShort(event.startsAt)} ${event.startsAt.day}, '
        '${Formatters.time24(event.startsAt)} ${AppStrings.timezone}';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.iconButtonSm,
            height: AppSizes.iconButtonSm,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
            ),
            child: const Icon(
              Icons.event,
              size: AppSizes.iconSm,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${event.title}: ${event.venue}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.label.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  event.note == null
                      ? when
                      : '$when ${AppStrings.bulletSeparator} ${event.note}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Material(
            color: AppColors.primary,
            shape: const StadiumBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Text(
                  AppStrings.rsvpNow,
                  style: AppTypography.buttonSmall.copyWith(
                    color: AppColors.textOnDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
