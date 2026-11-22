// Notification settings screen.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/notification_prefs_model.dart';
import '../../../shared/widgets/cards/info_banner.dart';
import '../../../shared/widgets/cards/settings_section.dart';
import '../../../shared/widgets/feedback/app_snack_bar.dart';
import '../../../shared/widgets/feedback/error_state.dart';
import '../../../shared/widgets/feedback/loading_indicator.dart';
import '../providers/inbox_provider.dart';
import '../providers/notification_prefs_provider.dart';
import '../widgets/notification_toggle_tile.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key, this.onBack});

  final VoidCallback? onBack;

  static const Map<NotificationTopic, (IconData, String, String)> _topics = {
    NotificationTopic.announcements: (
      Icons.campaign_outlined,
      AppStrings.topicAnnouncements,
      AppStrings.topicAnnouncementsSubtitle,
    ),
    NotificationTopic.marketplace: (
      Icons.storefront_outlined,
      AppStrings.topicMarketplace,
      AppStrings.topicMarketplaceSubtitle,
    ),
    NotificationTopic.messages: (
      Icons.chat_bubble_outline,
      AppStrings.topicMessages,
      AppStrings.topicMessagesSubtitle,
    ),
  };

  Future<void> _apply(BuildContext context, Future<bool> change) async {
    if (!await change && context.mounted) {
      showAppSnackBar(context, AppStrings.settingNotSaved);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(notificationPrefsProvider);
    final controller = ref.read(notificationPrefsProvider.notifier);
    final permissionDenied = ref.watch(notificationPermissionProvider) == false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          tooltip: AppStrings.goBack,
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: Text(
          AppStrings.notificationSettings,
          style: AppTypography.headingMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: switch (prefs) {
        AsyncData(value: final current) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            if (permissionDenied) ...[
              const InfoBanner(
                tone: InfoBannerTone.warning,
                title: AppStrings.notificationsOffTitle,
                message: AppStrings.notificationsOffMessage,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            SettingsSection(
              title: AppStrings.pushSection,
              children: [
                for (final MapEntry(key: topic, value: (icon, title, subtitle))
                    in _topics.entries)
                  NotificationToggleTile(
                    icon: icon,
                    title: title,
                    subtitle: subtitle,
                    value: current.isOn(topic),
                    onChanged: (on) =>
                        _apply(context, controller.setTopic(topic, on)),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            SettingsSection(
              title: AppStrings.whileOpenSection,
              children: [
                NotificationToggleTile(
                  icon: Icons.notifications_active_outlined,
                  title: AppStrings.inAppAlerts,
                  subtitle: AppStrings.inAppAlertsSubtitle,
                  value: current.inAppAlerts,
                  onChanged: (on) =>
                      _apply(context, controller.setInAppAlerts(on)),
                ),
              ],
            ),
          ],
        ),
        AsyncError() => ErrorState(
          onRetry: () => ref.invalidate(notificationPrefsProvider),
        ),
        _ => const LoadingIndicator(),
      },
    );
  }
}
