// Input for a listing's price.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

// Large digits-only field with an "RWF" prefix.
class PriceInput extends StatelessWidget {
  const PriceInput({super.key, required this.controller, this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
    );

    return SizedBox(
      height: AppSizes.priceInputHeight,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(AppSizes.priceMaxDigits),
        ],
        style: AppTypography.priceLarge.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.navyTint,
          hintText: '0',
          hintStyle: AppTypography.priceLarge.copyWith(
            color: AppColors.textMuted,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.sm,
            ),
            child: Text(
              AppStrings.currencyRwf,
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
          ),
          border: border,
          enabledBorder: border,
          focusedBorder: border,
        ),
      ),
    );
  }
}
