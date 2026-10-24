// Splash screen shown on app launch.
<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/buttons/primary_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: AppColors.onboardingGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                0,
                AppSpacing.xl,
                AppSpacing.sm,
              ),
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    AppStrings.splashTitle,
                    textAlign: TextAlign.center,
                    style: AppTypography.displayLarge.copyWith(
                      color: AppColors.textOnDark,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppSizes.onboardingTextMaxWidth,
                    ),
                    child: Text(
                      AppStrings.splashSubtitle,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textOnDark,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Navigation to login is wired up with routing later.
                  PrimaryButton(label: AppStrings.getStarted, onPressed: () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
=======
>>>>>>> dev
