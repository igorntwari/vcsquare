// White "Continue with Google" button on the login screen.
import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        side: BorderSide(
          color: AppColors.glassBorder,
          width: AppSizes.borderThin,
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppAssets.googleLogo,
                width: AppSizes.iconSm,
                height: AppSizes.iconSm,
                // Shows nothing until the logo file is added to assets/icons.
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                AppStrings.continueWithGoogle,
                style: AppTypography.bodySmallRegular.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
