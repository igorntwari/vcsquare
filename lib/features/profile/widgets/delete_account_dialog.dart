// Delete confirmation. Returns the password ('' for Google) or null.
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/inputs/app_form_field.dart';

Future<String?> showDeleteAccountDialog(
  BuildContext context, {
  required bool needsPassword,
}) => showDialog<String>(
  context: context,
  builder: (context) => DeleteAccountDialog(needsPassword: needsPassword),
);

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key, required this.needsPassword});

  final bool needsPassword;

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  void _confirm() {
    if (widget.needsPassword && !_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(widget.needsPassword ? _password.text : '');
  }

  @override
  Widget build(BuildContext context) {
    final bodyStyle = AppTypography.bodyMedium.copyWith(
      color: AppColors.textSecondary,
    );

    return AlertDialog(
      title: Text(
        AppStrings.deleteAccountConfirmTitle,
        style: AppTypography.headingMedium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(AppStrings.deleteAccountConfirmBody, style: bodyStyle),
              const SizedBox(height: AppSpacing.md),
              Text(
                widget.needsPassword
                    ? AppStrings.deleteAccountPasswordPrompt
                    : AppStrings.deleteAccountGooglePrompt,
                style: bodyStyle,
              ),
              if (widget.needsPassword) ...[
                const SizedBox(height: AppSpacing.md),
                AppFormField(
                  controller: _password,
                  label: AppStrings.passwordLabel,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  validator: Validators.signInPassword,
                  onFieldSubmitted: (_) => _confirm(),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            AppStrings.cancel,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        TextButton(
          onPressed: _confirm,
          child: Text(
            AppStrings.deleteForever,
            style: AppTypography.titleMedium.copyWith(color: AppColors.error),
          ),
        ),
      ],
    );
  }
}
