// Card for a verified official campus account.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/official_handle_model.dart';
import '../../../shared/widgets/buttons/follow_join_button.dart';
import '../../../shared/widgets/cards/app_card.dart';
import '../../../shared/widgets/chips/status_tag.dart';

class OfficialHandleCard extends StatelessWidget {
  const OfficialHandleCard({
    super.key,
    required this.handle,
    required this.isFollowing,
    this.onFollow,
  });

  final OfficialHandleModel handle;
  final bool isFollowing;
  final VoidCallback? onFollow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.handleCardWidth,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: AppSizes.avatarXl,
                      height: AppSizes.avatarXl,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        handle.icon,
                        size: AppSizes.iconMd,
                        color: AppColors.textOnDark,
                      ),
                    ),
                    Positioned(
                      right: -AppSpacing.xxs,
                      bottom: -AppSpacing.xxs,
                      child: Container(
                        width: AppSizes.avatarXxxs,
                        height: AppSizes.avatarXxxs,
                        decoration: BoxDecoration(
                          color: AppColors.greenSurface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.surface,
                            width: AppSizes.borderThick,
                          ),
                        ),
                        child: const Icon(
                          Icons.verified,
                          size: AppSizes.iconXs,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: StatusTag(
                      label: handle.category,
                      backgroundColor: AppColors.greenSurface,
                      foregroundColor: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              handle.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              handle.handle,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Expanded(
              child: Text(
                handle.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            FollowJoinButton(
              label: AppStrings.follow,
              activeLabel: AppStrings.following,
              isActive: isFollowing,
              style: FollowJoinStyle.prominent,
              expand: true,
              onPressed: onFollow,
            ),
          ],
        ),
      ),
    );
  }
}
