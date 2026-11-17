// Sign in with an ALU email and password, or with an ALU Google account.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import '../providers/terms_provider.dart';
import '../widgets/auth_link_row.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_button.dart';
import '../widgets/google_sign_in_button.dart';
import '../widgets/hub_live_card.dart';
import '../widgets/or_divider.dart';
import '../widgets/terms_agreement.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({
    super.key,
    this.onCreateAccount,
    this.onForgotPassword,
    this.onWhyInstitutionalLogin,
  });

  final VoidCallback? onCreateAccount;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onWhyInstitutionalLogin;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _termsAccepted() {
    if (ref.read(termsAcceptedProvider)) return true;
    showAppSnackBar(context, AppStrings.acceptTermsFirst);
    return false;
  }

  void _signInWithEmail() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate() || !_termsAccepted()) return;
    ref
        .read(authControllerProvider.notifier)
        .signInWithEmail(email: _email.text.trim(), password: _password.text);
  }

  void _signInWithGoogle() {
    if (!_termsAccepted()) return;
    ref.read(authControllerProvider.notifier).signInWithGoogle();
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
    final termsAccepted = ref.watch(termsAcceptedProvider);
    final footerStyle = AppTypography.bodySmall.copyWith(
      color: AppColors.textOnDarkFaint,
    );

    return AuthScaffold(
      title: AppStrings.signInTitle,
      subtitle: AppStrings.signInSubtitle,
      children: [
        Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                  hintText: AppStrings.passwordHint,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  onDark: true,
                  enabled: !busy,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  validator: Validators.signInPassword,
                  onFieldSubmitted: (_) => _signInWithEmail(),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: AuthTextButton(
            label: AppStrings.forgotPassword,
            onTap: busy ? null : widget.onForgotPassword,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TermsAgreement(
          accepted: termsAccepted,
          onToggle: ref.read(termsAcceptedProvider.notifier).toggle,
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: AppStrings.signIn,
          isLoading: busy,
          onPressed: _signInWithEmail,
        ),
        const SizedBox(height: AppSpacing.lg),
        const OrDivider(),
        const SizedBox(height: AppSpacing.lg),
        GoogleSignInButton(onPressed: busy ? null : _signInWithGoogle),
        const SizedBox(height: AppSpacing.md),
        AuthLinkRow(
          prompt: AppStrings.noAccountPrompt,
          link: AppStrings.createAccountLink,
          onTap: busy ? null : widget.onCreateAccount,
        ),
        Center(
          child: AuthTextButton(
            label: AppStrings.whyInstitutionalLogin,
            onTap: widget.onWhyInstitutionalLogin,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        const HubLiveCard(),
        const SizedBox(height: AppSpacing.xl),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.sm,
          children: [
            Text(AppStrings.universityName, style: footerStyle),
            Text(AppStrings.bulletSeparator, style: footerStyle),
            Text(AppStrings.studentLifeDivision, style: footerStyle),
          ],
        ),
      ],
    );
  }
}
