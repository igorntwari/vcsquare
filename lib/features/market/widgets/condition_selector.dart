// Selector for an item's condition.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/listing_model.dart';

// 2x2 grid of condition cards. The selected card turns navy with an orange
// check and ring.
class ConditionSelector extends StatelessWidget {
  const ConditionSelector({super.key, this.selected, this.onSelected});

  final ListingCondition? selected;
  final ValueChanged<ListingCondition>? onSelected;

  static const List<(ListingCondition, String, String)> _options = [
    (ListingCondition.brandNew, AppStrings.conditionNew, AppStrings.conditionNewHint),
    (
      ListingCondition.likeNew,
      AppStrings.conditionLikeNew,
      AppStrings.conditionLikeNewHint,
    ),
    (ListingCondition.used, AppStrings.conditionUsed, AppStrings.conditionUsedHint),
    (
      ListingCondition.forParts,
      AppStrings.conditionForParts,
      AppStrings.conditionForPartsHint,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: 2,
      children: [
        for (final (condition, title, hint) in _options)
          _buildOption(condition, title, hint),
      ],
    );
  }

  Widget _buildOption(ListingCondition condition, String title, String hint) {
    final isSelected = condition == selected;

    return Semantics(
      button: true,
      selected: isSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
          boxShadow: isSelected ? AppShadows.selectionRing : AppShadows.card,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
            onTap: () => onSelected?.call(condition),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTypography.titleLarge.copyWith(
                            color: isSelected
                                ? AppColors.textOnDark
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        width: AppSizes.iconSm,
                        height: AppSizes.iconSm,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.orangeAccent
                              : AppColors.chipBackground,
                          shape: BoxShape.circle,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: AppSizes.iconXs,
                                color: AppColors.textPrimary,
                              )
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    hint,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      color: isSelected
                          ? AppColors.textOnDarkMuted
                          : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
