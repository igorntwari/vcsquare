// Red floating "Sell an Item" button on the marketplace.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class SellItemButton extends StatelessWidget {
  const SellItemButton({super.key, this.onPressed});

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
                const Icon(
                  Icons.photo_camera_outlined,
                  size: AppSizes.iconSm,
                  color: AppColors.textOnDark,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  AppStrings.sellAnItem,
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
