// Single category tile in the category grid.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/category_model.dart';

// White tile with an icon circle and a label. Navy circle when selected.
class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.category,
    this.selected = false,
    this.onTap,
  });

  final CategoryModel category;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          boxShadow: AppShadows.card,
        ),
        child: Material(
          color: AppColors.surface,
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: AppSizes.categoryIconCircle,
                    height: AppSizes.categoryIconCircle,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : AppColors.surfaceMuted,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      category.icon,
                      size: AppSizes.iconSm,
                      color: selected
                          ? AppColors.textOnDark
                          : AppColors.iconDefault,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTypography.captionStrong.copyWith(
                      color: selected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
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
