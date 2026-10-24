// Institutional login screen.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/layout/gradient_background.dart';
import '../widgets/google_sign_in_button.dart';
import '../widgets/hub_live_card.dart';
import '../widgets/terms_agreement.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
    this.onContinueWithGoogle,
    this.onWhyInstitutionalLogin,
  });

  final VoidCallback? onContinueWithGoogle;
  final VoidCallback? onWhyInstitutionalLogin;

  @override
  Widget build(BuildContext context) {
    final footerStyle = AppTypography.bodySmall.copyWith(
      color: AppColors.textOnDarkFaint,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: GradientBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.xxxl),
                  Text(
                    AppStrings.splashTitle,
                    textAlign: TextAlign.center,
                    style: AppTypography.displayLarge.copyWith(
                      color: AppColors.textOnDark,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    AppStrings.splashSubtitle,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textOnDark,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  GoogleSignInButton(onPressed: onContinueWithGoogle),
                  const SizedBox(height: AppSpacing.xl),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: onWhyInstitutionalLogin,
                      child: Text(
                        AppStrings.whyInstitutionalLogin,
                        style: AppTypography.bodySmallRegular.copyWith(
                          color: AppColors.textOnDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  const HubLiveCard(),
                  const SizedBox(height: AppSpacing.xxxl),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: TermsAgreement(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: AppSpacing.sm,
                    children: [
                      Text(AppStrings.universityName, style: footerStyle),
                      Text(AppStrings.bulletSeparator, style: footerStyle),
                      Text(AppStrings.studentLifeDivision, style: footerStyle),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
