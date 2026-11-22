// Tappable row on a white card: leading icon, title, subtitle, trailing.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class ListTileCard extends StatelessWidget {
  const ListTileCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor = AppColors.iconDefault,
    this.iconBackground = AppColors.surfaceMuted,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;

  // Shown in a tinted circle. Ignored when [leading] is set.
  final IconData? icon;
  final Color iconColor;
  final Color iconBackground;

  // Custom leading widget, e.g. a UserAvatar.
  final Widget? leading;

  // Defaults to a chevron when [onTap] is set.
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(AppRadius.md));
    final lead =
        leading ??
        (icon == null
            ? null
            : Container(
                width: AppSizes.iconCircleMd,
                height: AppSizes.iconCircleMd,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: AppSizes.iconMd, color: iconColor),
              ));
    final trail =
        trailing ??
        (onTap == null
            ? null
            : const Icon(
                Icons.chevron_right,
                size: AppSizes.iconMd,
                color: AppColors.iconMuted,
              ));

    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: radius,
        boxShadow: AppShadows.card,
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                if (lead != null) ...[
                  lead,
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trail != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  trail,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
