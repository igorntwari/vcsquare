// List tile for a profile settings option.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

// Icon box, title, subtitle and a chevron. A green verified subtitle shows a
// check before the text.
class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor = AppColors.iconDefault,
    this.iconBackground = AppColors.chipBackground,
    this.isVerified = false,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color iconBackground;
  final bool isVerified;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final subtitleColor = isVerified ? AppColors.success : AppColors.textMuted;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: AppSizes.settingsIconBox,
              height: AppSizes.settingsIconBox,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppRadius.sm),
                ),
              ),
              child: Icon(icon, size: AppSizes.iconMd, color: iconColor),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      if (isVerified) ...[
                        Icon(
                          Icons.check_circle,
                          size: AppSizes.iconXs,
                          color: subtitleColor,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                      ],
                      Expanded(
                        child: Text(
                          subtitle,
                          style:
                              (isVerified
                                      ? AppTypography.label
                                      : AppTypography.bodySmall)
                                  .copyWith(color: subtitleColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: AppSizes.iconMd,
              color: AppColors.iconMuted,
            ),
          ],
        ),
      ),
    );
  }
}
