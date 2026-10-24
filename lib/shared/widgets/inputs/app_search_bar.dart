// Search bar input used across the app.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

// Pill search field for the navy header, with a round filter button.
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    required this.hintText,
    this.onDark = true,
    this.showFilter = true,
    this.onChanged,
    this.onFilterTap,
  });

  final String hintText;

  // True on the navy header, false on light backgrounds.
  final bool onDark;
  final bool showFilter;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    const pillBorder = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
    );
    final textColor = onDark ? AppColors.textOnDark : AppColors.textPrimary;

    return SizedBox(
      height: AppSizes.tapTarget,
      child: TextField(
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        cursorColor: textColor,
        style: AppTypography.bodyMedium.copyWith(color: textColor),
        decoration: InputDecoration(
          filled: true,
          fillColor: onDark
              ? AppColors.searchFieldOnDark
              : AppColors.searchFieldOnLight,
          hintText: hintText,
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textMuted,
          ),
          contentPadding: EdgeInsets.zero,
          border: pillBorder,
          enabledBorder: pillBorder,
          focusedBorder: pillBorder,
          prefixIcon: const Icon(
            Icons.search,
            size: AppSizes.iconSm,
            color: AppColors.textMuted,
          ),
          suffixIcon: !showFilter ? null : Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Material(
              color: AppColors.searchActionBackground,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onFilterTap,
                child: const SizedBox.square(
                  dimension: AppSizes.iconButtonXs,
                  child: Icon(
                    Icons.tune,
                    size: AppSizes.iconXs,
                    color: AppColors.iconDefault,
                    semanticLabel: AppStrings.searchFilter,
                  ),
                ),
              ),
            ),
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: AppSizes.iconButtonXs,
            minHeight: AppSizes.iconButtonXs,
          ),
        ),
      ),
    );
  }
}
