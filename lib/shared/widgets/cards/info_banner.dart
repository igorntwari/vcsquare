// Inline message box for tips, notices and warnings.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

enum InfoBannerTone { tip, success, warning, error }

// Muted rounded box with a tinted icon circle, a bold title and a body line.
// Same look as the Market's exchange tip.
class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.tone = InfoBannerTone.tip,
    this.action,
  });

  final String title;
  final String? message;

  // Defaults to an icon that matches [tone].
  final IconData? icon;
  final InfoBannerTone tone;

  // Optional trailing widget, e.g. a TextButton.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final (IconData defaultIcon, Color iconColor, Color iconBackground) =
        switch (tone) {
          InfoBannerTone.tip => (
            Icons.lightbulb_outline,
            AppColors.orangeDeep,
            AppColors.orangeSurface,
          ),
          InfoBannerTone.success => (
            Icons.check_circle_outline,
            AppColors.success,
            AppColors.greenSurface,
          ),
          InfoBannerTone.warning => (
            Icons.warning_amber_rounded,
            AppColors.orangeDeep,
            AppColors.orangeSurface,
          ),
          InfoBannerTone.error => (
            Icons.error_outline,
            AppColors.error,
            AppColors.redSurface,
          ),
        };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSizes.iconButtonSm,
            height: AppSizes.iconButtonSm,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon ?? defaultIcon,
              size: AppSizes.iconSm,
              color: iconColor,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.label.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                if (message != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    message!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: AppSpacing.sm),
            action!,
          ],
        ],
      ),
    );
  }
}
