// Divider between email and Google sign-in.
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    const line = Expanded(child: Divider(color: AppColors.glassBorder));
    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            AppStrings.orDivider,
            style: AppTypography.bodySmallRegular.copyWith(
              color: AppColors.textOnDarkSoft,
            ),
          ),
        ),
        line,
      ],
    );
  }
}
