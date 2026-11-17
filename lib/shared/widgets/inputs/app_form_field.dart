// Labelled form field with validation and an optional password toggle.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class AppFormField extends StatefulWidget {
  const AppFormField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.icon,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onFieldSubmitted,
    this.isPassword = false,
    this.onDark = false,
    this.enabled = true,
    this.maxLength,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final IconData? icon;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onFieldSubmitted;

  final bool isPassword;

  final bool onDark;
  final bool enabled;
  final int? maxLength;
  final int maxLines;
  final TextCapitalization textCapitalization;

  @override
  State<AppFormField> createState() => _AppFormFieldState();
}

class _AppFormFieldState extends State<AppFormField> {
  late final ValueNotifier<bool> _obscured = ValueNotifier(widget.isPassword);

  @override
  void dispose() {
    _obscured.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(AppRadius.md));
    final errorColor = widget.onDark ? AppColors.errorOnDark : AppColors.error;
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: color, width: width),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.label,
          style: AppTypography.label.copyWith(
            color: widget.onDark
                ? AppColors.textOnDarkSoft
                : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        ValueListenableBuilder<bool>(
          valueListenable: _obscured,
          builder: (context, obscured, _) => TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            enabled: widget.enabled,
            obscureText: obscured,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            autofillHints: widget.autofillHints,
            onFieldSubmitted: widget.onFieldSubmitted,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            minLines: 1,
            autocorrect: !widget.isPassword,
            enableSuggestions: !widget.isPassword,
            textCapitalization: widget.textCapitalization,
            inputFormatters: [
              if (widget.maxLength != null)
                LengthLimitingTextInputFormatter(widget.maxLength),
            ],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: widget.enabled
                  ? AppColors.surface
                  : AppColors.surfaceMuted,
              hintText: widget.hintText,
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
              errorStyle: AppTypography.caption.copyWith(color: errorColor),
              errorMaxLines: 2,
              prefixIcon: widget.icon == null
                  ? null
                  : Icon(
                      widget.icon,
                      size: AppSizes.iconSm,
                      color: AppColors.iconMuted,
                    ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      tooltip: obscured
                          ? AppStrings.showPassword
                          : AppStrings.hidePassword,
                      icon: Icon(
                        obscured
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: AppSizes.iconMd,
                        color: AppColors.iconMuted,
                      ),
                      onPressed: () => _obscured.value = !obscured,
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              border: border(AppColors.divider, AppSizes.borderThin),
              enabledBorder: border(AppColors.divider, AppSizes.borderThin),
              disabledBorder: border(AppColors.divider, AppSizes.borderThin),
              focusedBorder: border(AppColors.primary, AppSizes.borderThick),
              errorBorder: border(errorColor, AppSizes.borderThin),
              focusedErrorBorder: border(errorColor, AppSizes.borderThick),
            ),
          ),
        ),
      ],
    );
  }
}
