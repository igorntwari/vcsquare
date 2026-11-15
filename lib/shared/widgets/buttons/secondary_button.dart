// Secondary outlined button used across the app.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

// Full-width white button with a navy outline, for the less important
// action next to a PrimaryButton (e.g. "Save draft" beside "Preview").
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final color = onPressed == null ? AppColors.textMuted : AppColors.primary;
    final labelText = Text(
      label,
      textAlign: TextAlign.center,
      style: AppTypography.button.copyWith(color: color),
    );

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: AppColors.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
          side: BorderSide(color: color, width: AppSizes.borderThin),
        ),
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: icon == null
                ? labelText
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: AppSizes.iconMd, color: color),
                      const SizedBox(width: AppSpacing.xs),
                      labelText,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
