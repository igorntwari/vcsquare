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

// Student, office or club post. Club posts get a Join button; event posts
// get the navy flyer and an "Add to Calendar" action.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.isLiked,
    required this.likeCount,
    this.isJoined = false,
    this.onLike,
    this.onJoin,
  });

  final PostModel post;
  final bool isLiked;
  final int likeCount;
  final bool isJoined;
  final VoidCallback? onLike;
  final VoidCallback? onJoin;

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
          if (event != null && event.showAsBanner) ...[
            const SizedBox(height: AppSpacing.md),
            EventBannerCard(event: event),
          ],
          PostActionsRow(
            likeCount: likeCount,
            commentCount: post.commentCount,
            isLiked: isLiked,
            onLike: onLike,
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
        onTap: () {},
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.pill)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.addToCalendar,
                style: AppTypography.label.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(
                Icons.event_outlined,
                size: AppSizes.iconSm,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),
      );
    }
    return null;
  }
}
