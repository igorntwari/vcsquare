// Badge showing an unread or notification count.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class CountBadge extends StatelessWidget {
  const CountBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.countBadge,
      constraints: const BoxConstraints(minWidth: AppSizes.countBadge),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
      ),
      child: Text(
        '$count',
        style: AppTypography.caption.copyWith(color: AppColors.textOnDark),
      ),
    );
  }
}
