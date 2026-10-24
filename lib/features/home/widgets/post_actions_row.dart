// Row of like, comment and share actions on a post.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';

class PostActionsRow extends StatelessWidget {
  const PostActionsRow({
    super.key,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
    this.onLike,
    this.trailing,
  });

  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final VoidCallback? onLike;

  // Shown on the right (e.g. "Mandatory Read"). Defaults to a save button.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final likeColor = isLiked ? AppColors.likeActive : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
        children: [
          Semantics(
            button: true,
            toggled: isLiked,
            label: AppStrings.like,
            child: _buildCount(
              icon: isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
              count: likeCount,
              color: likeColor,
              onTap: onLike,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Semantics(
            button: true,
            label: AppStrings.comment,
            child: _buildCount(
              icon: Icons.chat_bubble_outline,
              count: commentCount,
              color: AppColors.textSecondary,
              onTap: () {},
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            tooltip: AppStrings.share,
            onPressed: () {},
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.share_outlined,
              size: AppSizes.iconSm,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          trailing ??
              IconButton(
                tooltip: AppStrings.save,
                onPressed: () {},
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.bookmark_border,
                  size: AppSizes.iconMd,
                  color: AppColors.textSecondary,
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildCount({
    required IconData icon,
    required int count,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.pill)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppSizes.iconSm, color: color),
            const SizedBox(width: AppSpacing.xs),
            Text(
              Formatters.compactCount(count),
              style: AppTypography.label.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
