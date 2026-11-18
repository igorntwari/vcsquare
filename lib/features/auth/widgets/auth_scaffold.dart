// Shared layout for the sign-in screens.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/layout/gradient_background.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.onBack,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: GradientBackground(
          child: SafeArea(
            child: Column(
              children: [
                if (onBack != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      tooltip: AppStrings.goBack,
                      onPressed: onBack,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.textOnDark,
                      ),
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.lg,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: AppSizes.authFormMaxWidth,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: AppTypography.headingLarge.copyWith(
                                color: AppColors.textOnDark,
                              ),
                            ),
                            if (subtitle != null) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                subtitle!,
                                textAlign: TextAlign.center,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textOnDarkSoft,
                                ),
                              ),
                            ],
                            const SizedBox(height: AppSpacing.xl),
                            ...children,
                          ],
                        ),
                      ),
                    ),
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
