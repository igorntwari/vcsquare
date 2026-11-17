// Email and password sign-up.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../data/repositories/auth/auth_failure.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/feedback/app_snack_bar.dart';
import '../../../shared/widgets/inputs/app_form_field.dart';
import '../providers/auth_controller.dart';
import '../providers/terms_provider.dart';
import '../widgets/auth_link_row.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/terms_agreement.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key, this.onBack, this.onSignIn});

  final VoidCallback? onBack;

  final VoidCallback? onSignIn;

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (!ref.read(termsAcceptedProvider)) {
      showAppSnackBar(context, AppStrings.acceptTermsFirst);
      return;
    }
    ref
        .read(authControllerProvider.notifier)
        .signUp(
          name: _name.text.trim(),
          email: _email.text.trim(),
          password: _password.text,
        );
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

    return AuthScaffold(
      title: AppStrings.signUpTitle,
      subtitle: AppStrings.signUpSubtitle,
      onBack: busy ? null : widget.onBack,
      children: [
        Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppFormField(
                  controller: _name,
                  label: AppStrings.fullNameLabel,
                  hintText: AppStrings.fullNameHint,
                  icon: Icons.person_outline,
                  onDark: true,
                  enabled: !busy,
                  maxLength: AppSizes.nameMaxLength,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  validator: Validators.name,
                ),
                const SizedBox(height: AppSpacing.md),
                AppFormField(
                  controller: _email,
                  label: AppStrings.emailLabel,
                  hintText: AppStrings.emailHint,
                  icon: Icons.mail_outline,
                  onDark: true,
                  enabled: !busy,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: Validators.email,
                ),
                const SizedBox(height: AppSpacing.md),
                AppFormField(
                  controller: _password,
                  label: AppStrings.passwordLabel,
                  hintText: AppStrings.newPasswordHint,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  onDark: true,
                  enabled: !busy,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  validator: Validators.newPassword,
                ),
                const SizedBox(height: AppSpacing.md),
                AppFormField(
                  controller: _confirm,
                  label: AppStrings.confirmPasswordLabel,
                  hintText: AppStrings.confirmPasswordHint,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  onDark: true,
                  enabled: !busy,
                  textInputAction: TextInputAction.done,
                  // Read the password at validation time, not build time.
                  validator: (value) =>
                      Validators.confirmPassword(_password.text)(value),
                  onFieldSubmitted: (_) => _submit(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        TermsAgreement(
          accepted: ref.watch(termsAcceptedProvider),
          onToggle: ref.read(termsAcceptedProvider.notifier).toggle,
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: AppStrings.createAccount,
          isLoading: busy,
          onPressed: _submit,
        ),
        const SizedBox(height: AppSpacing.md),
        AuthLinkRow(
          prompt: AppStrings.haveAccountPrompt,
          link: AppStrings.signInLink,
          onTap: busy ? null : widget.onSignIn,
        ),
      ],
    );
  }
}
