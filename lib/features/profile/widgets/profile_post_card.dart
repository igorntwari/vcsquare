// Compact card for one of the user's own posts on their profile.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/post_model.dart';
import '../../../shared/widgets/avatars/user_avatar.dart';
import '../../../shared/widgets/cards/app_card.dart';

class ProfilePostCard extends StatelessWidget {
  const ProfilePostCard({
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
    final meta = post.audience == null
        ? Formatters.timeAgo(post.createdAt)
        : '${Formatters.timeAgo(post.createdAt)} '
              '${AppStrings.bulletSeparator} ${post.audience}';
    final likeColor = isLiked ? AppColors.likeActive : AppColors.textMuted;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatar(
                size: AppSizes.settingsIconBox,
                imagePath: post.author.avatarPath,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author.name,
                      style: AppTypography.label.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: AppStrings.moreOptions,
                onPressed: () {},
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.more_horiz,
                  size: AppSizes.iconMd,
                  color: AppColors.iconMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            post.body,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          if (post.imagePath != null) ...[
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(AppRadius.sm),
              ),
              child: Image.asset(
                post.imagePath!,
                height: AppSizes.profilePostImageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: AppSizes.profilePostImageHeight,
                  width: double.infinity,
                  color: AppColors.imagePlaceholder,
                  child: const Icon(
                    Icons.image_outlined,
                    size: AppSizes.iconLg,
                    color: AppColors.iconMuted,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Semantics(
                button: true,
                toggled: isLiked,
                label: AppStrings.like,
                child: InkWell(
                  onTap: onLike,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(AppRadius.pill),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    child: Row(
                      children: [
                        Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          size: AppSizes.iconSm,
                          color: likeColor,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          Formatters.compactCount(likeCount),
                          style: AppTypography.buttonSmall.copyWith(
                            color: likeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const Icon(
                Icons.chat_bubble_outline,
                size: AppSizes.iconSm,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                Formatters.compactCount(post.commentCount),
                style: AppTypography.buttonSmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: AppStrings.share,
                onPressed: () {},
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.share_outlined,
                  size: AppSizes.iconSm,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
