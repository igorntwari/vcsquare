// Navy "ALU Peer Trade Guard" banner reassuring buyers about sellers.
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class TrustBanner extends StatelessWidget {
  const TrustBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        boxShadow: AppShadows.card,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -AppSpacing.lg,
            bottom: -AppSpacing.lg,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                width: AppSizes.trustBannerFlare,
                height: AppSizes.trustBannerFlare,
                decoration: const BoxDecoration(
                  color: AppColors.trustBannerFlare,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: AppSizes.iconCircleMd,
                  height: AppSizes.iconCircleMd,
                  decoration: const BoxDecoration(
                    color: AppColors.iconCircleOnDark,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_user_outlined,
                    size: AppSizes.iconSm,
                    color: AppColors.textOnDark,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.peerTradeGuardTitle,
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.textOnDark,
                        ),
                      ),
                      Text(
                        AppStrings.peerTradeGuardBody,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textOnDarkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
