// Screen explaining why login uses an institutional account.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/layout/gradient_background.dart';
import '../widgets/benefit_card.dart';

class WhyInstitutionalLoginScreen extends StatelessWidget {
  const WhyInstitutionalLoginScreen({super.key, this.onGoBack});

  final VoidCallback? onGoBack;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: GradientBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.xxxl),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppStrings.whyInstitutionalLoginTitle,
                            style: AppTypography.headingMedium.copyWith(
                              color: AppColors.textOnDark,
                            ),
                          ),
                        ),
                        Text(
                          AppStrings.campusProtection,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textOnDarkSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const BenefitCard(
                    icon: Icons.lock,
                    iconColor: AppColors.accent,
                    iconBackground: AppColors.redSurface,
                    title: AppStrings.verifiedCommunityTitle,
                    description: AppStrings.verifiedCommunityBody,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const BenefitCard(
                    icon: Icons.storefront,
                    iconColor: AppColors.success,
                    iconBackground: AppColors.greenSurface,
                    title: AppStrings.safeMarketplaceTitle,
                    description: AppStrings.safeMarketplaceBody,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const BenefitCard(
                    icon: Icons.groups,
                    iconColor: AppColors.primary,
                    iconBackground: AppColors.blueSurface,
                    title: AppStrings.officialClubsTitle,
                    description: AppStrings.officialClubsBody,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    child: PrimaryButton(
                      label: AppStrings.goBack,
                      icon: Icons.arrow_back,
                      onPressed: onGoBack,
                    ),
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
