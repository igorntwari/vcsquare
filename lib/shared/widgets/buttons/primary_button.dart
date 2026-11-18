// Primary filled button used across the app.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

// Full-width glossy navy button with a soft white outline.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final labelText = Text(
      label,
      textAlign: TextAlign.center,
      style: AppTypography.button.copyWith(color: AppColors.textOnDarkSoft),
    );

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: AppColors.primary,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          side: BorderSide(
            color: AppColors.glassBorder,
            width: AppSizes.borderThin,
          ),
        ),
        child: Ink(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryButtonSheen,
          ),
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: isLoading
                  ? const Center(
                      child: SizedBox.square(
                        dimension: AppSizes.iconMd,
                        child: CircularProgressIndicator(
                          strokeWidth: AppSizes.borderThick,
                          color: AppColors.textOnDarkSoft,
                          semanticsLabel: AppStrings.loading,
                        ),
                      ),
                    )
                  : icon == null
                  ? labelText
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: AppSizes.iconMd,
                          color: AppColors.textOnDarkSoft,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        labelText,
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
