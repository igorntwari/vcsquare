// Spinner shown while data loads.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

// Small accent-red spinner, centred in the space it is given.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.size = AppSizes.iconLg});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: SizedBox.square(
          dimension: size,
          child: const CircularProgressIndicator(
            strokeWidth: AppSizes.borderThick,
            color: AppColors.accent,
            semanticsLabel: AppStrings.loading,
          ),
        ),
      ),
    );
  }
}
