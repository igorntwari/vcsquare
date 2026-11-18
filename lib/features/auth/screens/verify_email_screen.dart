// Waits for the email to be verified, checking every few seconds.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/repositories/auth/auth_failure.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/feedback/app_snack_bar.dart';
import '../providers/auth_controller.dart';
import '../providers/resend_cooldown_provider.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_button.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key, required this.email});

  final String email;

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    // Deferred: providers can't change during build.
    Future.microtask(() {
      if (mounted) ref.read(resendCooldownProvider.notifier).start();
    });
    _poll = Timer.periodic(
      const Duration(seconds: AppSizes.verifyPollSeconds),
      (_) => _checkQuietly(),
    );
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _checkQuietly() async {
    try {
      await ref.read(authRepositoryProvider).reloadAccount();
    } on AuthFailure {
      // Retried on the next tick.
    }
  }

  Future<void> _check() async {
    final verified = await ref
        .read(authControllerProvider.notifier)
        .checkVerified();
    if (!verified && mounted && !ref.read(authControllerProvider).hasError) {
      showAppSnackBar(context, AppStrings.notVerifiedYet);
    }
  }

  Future<void> _resend() async {
    final sent = await ref
        .read(authControllerProvider.notifier)
        .resendVerification();
    if (!sent || !mounted) return;
    ref.read(resendCooldownProvider.notifier).start();
    showAppSnackBar(context, AppStrings.verificationSent);
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
    final cooldown = ref.watch(resendCooldownProvider);

    return AuthScaffold(
      title: AppStrings.verifyEmailTitle,
      children: [
        const Icon(
          Icons.mark_email_unread_outlined,
          size: AppSizes.avatarEdit,
          color: AppColors.textOnDark,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          AppStrings.verifyEmailBody(widget.email),
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textOnDarkSoft,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
          label: AppStrings.iVerified,
          isLoading: busy,
          onPressed: _check,
        ),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: AuthTextButton(
            label: cooldown > 0
                ? AppStrings.resendIn(cooldown)
                : AppStrings.resendEmail,
            onTap: cooldown > 0 || busy ? null : _resend,
          ),
        ),
        Center(
          child: AuthTextButton(
            label: AppStrings.useDifferentAccount,
            onTap: busy
                ? null
                : ref.read(authControllerProvider.notifier).signOut,
          ),
        ),
      ],
    );
  }
}
