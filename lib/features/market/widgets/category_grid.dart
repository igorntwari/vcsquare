// Grid of marketplace categories.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/category_model.dart';
import 'category_item.dart';

// Four-column grid. Tapping the selected category again clears the filter.
class CategoryGrid extends StatelessWidget {
  const CategoryGrid({
    super.key,
    required this.categories,
    this.selectedId,
    this.onSelected,
  });

  final List<CategoryModel> categories;
  final String? selectedId;
  final ValueChanged<String?>? onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisExtent: AppSizes.categoryTileHeight,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = category.id == selectedId;
        return CategoryItem(
          category: category,
          selected: isSelected,
          onTap: () => onSelected?.call(isSelected ? null : category.id),
        );
      },
    );
  }
}
