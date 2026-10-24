// Single selectable chip.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

// Pill chip with an optional leading icon or colored dot. Navy when selected.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.icon,
    this.dotColor,
    this.trailingIcon,
    this.trailingIconColor,
    this.onTap,
  });

  final String label;
  final bool selected;
  final IconData? icon;
  final Color? dotColor;

  // Icon after the label, e.g. the green check on "Verified Student Sellers".
  final IconData? trailingIcon;

  // Color of [trailingIcon] while unselected. Selected chips use white.
  final Color? trailingIconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? AppColors.textOnDark
        : AppColors.textSecondary;

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected
            ? AppColors.chipSelectedBackground
            : AppColors.chipBackground,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: AppSizes.chipHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: selected
                ? const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppRadius.pill),
                    ),
                    boxShadow: AppShadows.card,
                  )
                : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: AppSizes.iconSm, color: foreground),
                  const SizedBox(width: AppSpacing.sm),
                ] else if (dotColor != null) ...[
                  Container(
                    width: AppSizes.statusDot,
                    height: AppSizes.statusDot,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(
                  label,
                  style: AppTypography.label.copyWith(color: foreground),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: AppSpacing.xs),
                  Icon(
                    trailingIcon,
                    size: AppSizes.iconSm,
                    color: selected
                        ? foreground
                        : trailingIconColor ?? foreground,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
