// Red floating pill button with an icon ("Sell an Item", "New Chat").
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class FloatingPillButton extends StatelessWidget {
  const FloatingPillButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
        boxShadow: AppShadows.accentGlow,
      ),
      child: Material(
        color: AppColors.accent,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: AppSizes.iconSm, color: AppColors.textOnDark),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  label,
                  style: AppTypography.button.copyWith(
                    color: AppColors.textOnDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
