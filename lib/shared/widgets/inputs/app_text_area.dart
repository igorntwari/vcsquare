// Multi-line text input used across the app.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

// White rounded multi-line field with a soft shadow.
class AppTextArea extends StatelessWidget {
  const AppTextArea({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLength,
    this.minLines = 4,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final int? maxLength;
  final int minLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        boxShadow: AppShadows.card,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        minLines: minLines,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        inputFormatters: [
          if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
        ],
        style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.surface,
          hintText: hintText,
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textMuted,
          ),
          contentPadding: const EdgeInsets.all(AppSpacing.md),
          border: border,
          enabledBorder: border,
          focusedBorder: border,
        ),
      ),
    );
  }
}
