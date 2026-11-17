// Titled card of settings tiles.
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTypography.overline.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.sm),
        DecoratedBox(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
            boxShadow: AppShadows.card,
          ),
          child: Material(
            color: AppColors.surface,
            borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
            clipBehavior: Clip.antiAlias,
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}
