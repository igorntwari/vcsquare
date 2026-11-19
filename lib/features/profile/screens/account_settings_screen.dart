// Account settings: edit profile, sign out, delete account.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/auth_account_model.dart';
import '../../../data/repositories/auth/auth_failure.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../shared/widgets/feedback/app_snack_bar.dart';
import '../../../shared/widgets/feedback/loading_indicator.dart';
import '../providers/profile_controller.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/delete_account_dialog.dart';
import '../widgets/settings_list_tile.dart';
import '../../../shared/widgets/cards/settings_section.dart';

class AccountSettingsScreen extends ConsumerWidget {
  const AccountSettingsScreen({
    super.key,
    this.onBack,
    this.onEditProfile,
    this.onNotificationSettings,
  });

  final VoidCallback? onBack;
  final VoidCallback? onEditProfile;
  final VoidCallback? onNotificationSettings;

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: AppStrings.signOutConfirmTitle,
      message: AppStrings.signOutConfirmBody,
      confirmLabel: AppStrings.signOut,
    );
    if (confirmed) {
      await ref.read(profileControllerProvider.notifier).signOut();
    }
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final account = ref.read(authAccountProvider).value;
    final password = await showDeleteAccountDialog(
      context,
      needsPassword: account?.method != AuthMethod.google,
    );
    if (password == null) return;
    await ref
        .read(profileControllerProvider.notifier)
        .deleteAccount(password: password.isEmpty ? null : password);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(profileControllerProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        final message = error is AuthFailure
            ? error.message
            : AppStrings.authUnknown;
        if (message != null) showAppSnackBar(context, message);
      }
    });
    final busy = ref.watch(profileControllerProvider).isLoading;
    final email = ref.watch(authAccountProvider).value?.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          tooltip: AppStrings.goBack,
          icon: const Icon(Icons.arrow_back),
          onPressed: busy ? null : onBack,
        ),
        title: Text(
          AppStrings.accountSettings,
          style: AppTypography.headingMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: busy
          ? const LoadingIndicator()
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Text(
                  email,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SettingsSection(
                  title: AppStrings.accountSection,
                  children: [
                    SettingsListTile(
                      icon: Icons.edit_outlined,
                      title: AppStrings.editProfile,
                      subtitle: AppStrings.editProfileSubtitle,
                      onTap: onEditProfile,
                    ),
                    SettingsListTile(
                      icon: Icons.notifications_none,
                      title: AppStrings.notificationSettings,
                      subtitle: AppStrings.notificationSettingsSubtitle,
                      onTap: onNotificationSettings,
                    ),
                    SettingsListTile(
                      icon: Icons.logout,
                      title: AppStrings.signOut,
                      subtitle: AppStrings.signOutSubtitle,
                      onTap: () => _signOut(context, ref),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                SettingsSection(
                  title: AppStrings.dangerSection,
                  children: [
                    SettingsListTile(
                      icon: Icons.delete_forever_outlined,
                      iconColor: AppColors.error,
                      iconBackground: AppColors.redSurface,
                      title: AppStrings.deleteAccount,
                      subtitle: AppStrings.deleteAccountSubtitle,
                      onTap: () => _deleteAccount(context, ref),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
