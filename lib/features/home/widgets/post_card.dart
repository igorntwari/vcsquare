// Card showing a single feed post.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/post_model.dart';
import '../../../shared/widgets/buttons/follow_join_button.dart';
import '../../../shared/widgets/cards/app_card.dart';
import '../../../shared/widgets/chips/status_tag.dart';
import 'comment_preview_tile.dart';
import 'event_banner_card.dart';
import 'post_actions_row.dart';
import 'post_author_header.dart';
import 'post_body_text.dart';
import 'post_photo.dart';
import 'poll_card.dart';

// Student, office or club post. Club posts get a Join button; event posts
// get the navy flyer and an RSVP action that opens the event details.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.isLiked,
    required this.likeCount,
    this.isSaved = false,
    this.isRsvped = false,
    this.isJoined = false,
    this.onLike,
    this.onJoin,
    this.onComment,
    this.onShare,
    this.onSave,
    this.onMoreOptions,
    this.onEventTap,
    this.selectedPollOption,
    this.onVote,
  });

  final PostModel post;
  final bool isLiked;
  final int likeCount;
  final bool isSaved;
  final bool isRsvped;
  final bool isJoined;
  final VoidCallback? onLike;
  final VoidCallback? onJoin;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSave;
  final VoidCallback? onMoreOptions;
  final VoidCallback? onEventTap;
  final String? selectedPollOption;
  final ValueChanged<String>? onVote;

  @override
  Widget build(BuildContext context) {
    final event = post.event;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostAuthorHeader(
            author: post.author,
            timeAgo: Formatters.timeAgo(post.createdAt),
            onMoreOptions: onMoreOptions,
            audience: post.audience,
            trailing: post.author.isClub
                ? FollowJoinButton(
                    label: AppStrings.joinClub,
                    activeLabel: AppStrings.joined,
                    isActive: isJoined,
                    onPressed: onJoin,
                  )
                : null,
          ),
          const SizedBox(height: AppSpacing.sm),
          PostBodyText(title: post.title, body: post.body),
          if (post.imagePath != null) ...[
            const SizedBox(height: AppSpacing.md),
            PostPhoto(imagePath: post.imagePath!, caption: post.imageCaption),
          ],
          if (post.poll != null) ...[
            const SizedBox(height: AppSpacing.md),
            PollCard(
              poll: post.poll!,
              selectedOption: selectedPollOption,
              onVote: onVote,
            ),
          ],
          if (event != null && event.showAsBanner) ...[
            const SizedBox(height: AppSpacing.md),
            EventBannerCard(event: event),
          ],
          PostActionsRow(
            likeCount: likeCount,
            commentCount: post.commentCount,
            isLiked: isLiked,
            onLike: onLike,
            onComment: onComment,
            onShare: onShare,
            isSaved: isSaved,
            onSave: onSave,
            trailing: _buildTrailingAction(),
          ),
          if (post.commentPreview != null) ...[
            const SizedBox(height: AppSpacing.xs),
            CommentPreviewTile(comment: post.commentPreview!),
          ],
        ],
      ),
    );
  }

  Widget? _buildTrailingAction() {
    if (post.isMandatoryRead) {
      return const StatusTag(
        label: AppStrings.mandatoryRead,
        icon: Icons.done_all,
        backgroundColor: AppColors.greenSurface,
        foregroundColor: AppColors.success,
      );
    }
    if (post.event != null) {
      return InkWell(
        onTap: onEventTap,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.pill)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isRsvped ? AppStrings.rsvped : AppStrings.rsvpNow,
                style: AppTypography.label.copyWith(
                  color: isRsvped ? AppColors.success : AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                isRsvped ? Icons.event_available : Icons.event_outlined,
                size: AppSizes.iconSm,
                color: isRsvped ? AppColors.success : AppColors.textPrimary,
              ),
            ],
          ),
        ),
      );
    }
    return null;
  }
}
