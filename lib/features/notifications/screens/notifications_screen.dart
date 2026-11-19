// Inbox listing push notifications received on this device.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/notification_model.dart';
import '../../../shared/widgets/cards/info_banner.dart';
import '../../../shared/widgets/feedback/empty_state.dart';
import '../providers/inbox_provider.dart';
import '../widgets/notification_tile.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({
    super.key,
    this.onBack,
    this.onOpen,
    this.onOpenSettings,
  });

  final VoidCallback? onBack;

  final ValueChanged<NotificationModel>? onOpen;
  final VoidCallback? onOpenSettings;

  void _tap(WidgetRef ref, NotificationModel notification) {
    if (notification.data['screen'] != null && onOpen != null) {
      onOpen!(notification);
    } else {
      ref.read(inboxProvider.notifier).markRead(notification.id);
    }
  }

  void _remove(
    BuildContext context,
    WidgetRef ref,
    NotificationModel notification,
  ) {
    ref.read(inboxProvider.notifier).remove(notification.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text(AppStrings.notificationRemoved)),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(inboxProvider);
    final permissionDenied = ref.watch(notificationPermissionProvider) == false;
    final hasUnread = notifications.any((n) => !n.isRead);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            _buildHeader(context, ref, hasUnread),
            if (permissionDenied)
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  0,
                ),
                child: InfoBanner(
                  tone: InfoBannerTone.warning,
                  title: AppStrings.notificationsOffTitle,
                  message: AppStrings.notificationsOffMessage,
                ),
              ),
            Expanded(
              child: notifications.isEmpty
                  ? const SingleChildScrollView(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: EmptyState(
                        icon: Icons.notifications_none,
                        title: AppStrings.noNotificationsTitle,
                        message: AppStrings.noNotificationsMessage,
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.lg,
                        MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
                      ),
                      itemCount: notifications.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return Dismissible(
                          key: ValueKey(notification.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) =>
                              _remove(context, ref, notification),
                          background: _buildDismissBackground(),
                          child: NotificationTile(
                            notification: notification,
                            onTap: () => _tap(ref, notification),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, bool hasUnread) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.frostedSurface,
        boxShadow: AppShadows.card,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              IconButton(
                tooltip: AppStrings.back,
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.chipBackground,
                  fixedSize: const Size.square(AppSizes.iconCircleMd),
                ),
                icon: const Icon(
                  Icons.arrow_back,
                  size: AppSizes.iconSm,
                  color: AppColors.iconDefault,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.notifications,
                      style: AppTypography.headingMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      AppStrings.notificationsSubtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasUnread)
                TextButton(
                  onPressed: ref.read(inboxProvider.notifier).markAllRead,
                  child: Text(
                    AppStrings.markAllRead,
                    style: AppTypography.buttonSmall.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ),
              if (onOpenSettings != null)
                IconButton(
                  tooltip: AppStrings.notificationSettings,
                  onPressed: onOpenSettings,
                  icon: const Icon(
                    Icons.settings_outlined,
                    size: AppSizes.iconMd,
                    color: AppColors.iconDefault,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.redSurface,
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: const Icon(
        Icons.delete_outline,
        size: AppSizes.iconMd,
        color: AppColors.error,
      ),
    );
  }
}
