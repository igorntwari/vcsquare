// Chips for sorting marketplace results.
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

// Segmented pill control. The selected option is a navy pill.
class SortChips extends StatelessWidget {
  const SortChips({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: const BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < options.length; i++)
              Semantics(
                button: true,
                selected: i == selectedIndex,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onSelected(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: i == selectedIndex ? AppColors.primary : null,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(AppRadius.pill),
                      ),
                      boxShadow: i == selectedIndex ? AppShadows.card : null,
                    ),
                    child: Text(
                      options[i],
                      style: i == selectedIndex
                          ? AppTypography.buttonSmall.copyWith(
                              color: AppColors.textOnDark,
                            )
                          : AppTypography.chip.copyWith(
                              color: AppColors.textSecondary,
                            ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
