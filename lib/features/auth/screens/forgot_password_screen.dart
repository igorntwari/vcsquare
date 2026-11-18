// Sends a password reset link to an ALU email.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../data/repositories/auth/auth_failure.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/feedback/app_snack_bar.dart';
import '../../../shared/widgets/inputs/app_form_field.dart';
import '../providers/auth_controller.dart';
import '../widgets/auth_scaffold.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();

  final ValueNotifier<String?> _sentTo = ValueNotifier(null);

  @override
  void dispose() {
    _email.dispose();
    _sentTo.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final email = _email.text.trim();
    final sent = await ref
        .read(authControllerProvider.notifier)
        .sendPasswordReset(email);
    if (sent) _sentTo.value = email;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (_, next) {
      if (next case AsyncError(error: final AuthFailure failure)) {
        if (failure.message case final message?) {
          showAppSnackBar(context, message);
        }
      }
    });
    final busy = ref.watch(authControllerProvider).isLoading;

    return ValueListenableBuilder<String?>(
      valueListenable: _sentTo,
      builder: (context, sentTo, _) => sentTo == null
          ? AuthScaffold(
              title: AppStrings.resetPasswordTitle,
              subtitle: AppStrings.resetPasswordSubtitle,
              onBack: widget.onBack,
              children: [
                Form(
                  key: _formKey,
                  child: AppFormField(
                    controller: _email,
                    label: AppStrings.emailLabel,
                    hintText: AppStrings.emailHint,
                    icon: Icons.mail_outline,
                    onDark: true,
                    enabled: !busy,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.send,
                    autofillHints: const [AutofillHints.email],
                    validator: Validators.email,
                    onFieldSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: AppStrings.sendResetLink,
                  isLoading: busy,
                  onPressed: _send,
                ),
              ],
            )
          : AuthScaffold(
              title: AppStrings.resetLinkSentTitle,
              onBack: widget.onBack,
              children: [
                const Icon(
                  Icons.mark_email_read_outlined,
                  size: AppSizes.avatarEdit,
                  color: AppColors.textOnDark,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  AppStrings.resetLinkSent(sentTo),
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textOnDarkSoft,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: AppStrings.backToSignIn,
                  onPressed: widget.onBack,
                ),
              ],
            ),
    );
  }
}
