// Card highlighting live campus hub activity during onboarding.
import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class HubLiveCard extends StatelessWidget {
  const HubLiveCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Container(
              width: AppSizes.avatarXs,
              height: AppSizes.avatarXs,
              color: AppColors.primary,
              child: Image.asset(
                AppAssets.aluBadge,
                fit: BoxFit.cover,
                // Plain navy circle until the badge file is added.
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              AppStrings.activePeersOnline,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Row(
            children: [
              Container(
                width: AppSizes.statusDot,
                height: AppSizes.statusDot,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                AppStrings.hubLive,
                style: AppTypography.chip.copyWith(color: AppColors.success),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
