// Compact post result shown by Explore search and trending topics.
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/post_model.dart';
import '../../../shared/widgets/cards/app_card.dart';

class ExplorePostResultTile extends StatelessWidget {
  const ExplorePostResultTile({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${post.author.name} ${AppStrings.bulletSeparator} '
            '${post.author.handle}',
            style: AppTypography.captionStrong.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          if (post.title != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              post.title!,
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xs),
          Text(
            post.body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
