// Author row at the top of a post: avatar, name, badge, handle and time.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/user_model.dart';
import '../../../shared/widgets/avatars/user_avatar.dart';
import '../../../shared/widgets/badges/verified_badge.dart';
import '../../../shared/widgets/chips/status_tag.dart';

class PostAuthorHeader extends StatelessWidget {
  const PostAuthorHeader({
    super.key,
    required this.author,
    required this.timeAgo,
    this.audience,
    this.trailing,
  });

  final UserModel author;
  final String timeAgo;
  final String? audience;

  // Shown on the right. Defaults to a "more options" button.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final metaStyle = AppTypography.bodySmall.copyWith(
      color: AppColors.textMuted,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAvatar(),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xxs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    author.name,
                    style: AppTypography.headingMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  ?_buildBadge(),
                ],
              ),
              const SizedBox(height: AppSpacing.xxs),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xxs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(author.handle, style: metaStyle),
                  Text(AppStrings.bulletSeparator, style: metaStyle),
                  Text(timeAgo, style: metaStyle),
                  if (audience != null) ...[
                    Text(AppStrings.bulletSeparator, style: metaStyle),
                    StatusTag(
                      label: audience!,
                      icon: Icons.public,
                      backgroundColor: AppColors.chipBackground,
                      foregroundColor: AppColors.textSecondary,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        trailing ??
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
    );
  }

  // Students show their photo. Offices and clubs show a navy crest circle.
  Widget _buildAvatar() {
    if (author.isStudent) {
      return UserAvatar(size: AppSizes.avatarLg, imagePath: author.avatarPath);
    }
    return Container(
      width: AppSizes.avatarLg,
      height: AppSizes.avatarLg,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        author.isOfficial ? Icons.school : Icons.groups,
        size: AppSizes.iconMd,
        color: AppColors.textOnDark,
      ),
    );
  }

  Widget? _buildBadge() {
    if (author.isVerified) return const VerifiedBadge();
    if (author.isClub) {
      return const StatusTag(
        label: AppStrings.clubHub,
        backgroundColor: AppColors.chipBackground,
        foregroundColor: AppColors.textSecondary,
      );
    }
    if (author.cohort != null) {
      return StatusTag(
        label: author.cohort!,
        backgroundColor: AppColors.blueSurface,
        foregroundColor: AppColors.textPrimary,
      );
    }
    return null;
  }
}
