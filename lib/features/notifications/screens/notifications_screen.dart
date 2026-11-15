// Inbox listing push notifications received on this device.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/notification_model.dart';
import '../../../shared/widgets/feedback/empty_state.dart';
import '../widgets/notification_tile.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key, this.onBack});

  final VoidCallback? onBack;

  NotificationService get _service => NotificationService.instance;

  void _remove(BuildContext context, NotificationModel notification) {
    _service.remove(notification.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text(AppStrings.notificationRemoved)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: ValueListenableBuilder<List<NotificationModel>>(
          valueListenable: _service.notifications,
          builder: (context, notifications, _) {
            final hasUnread = notifications.any((n) => !n.isRead);
            return Column(
              children: [
                _buildHeader(context, hasUnread),
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
                            MediaQuery.paddingOf(context).bottom +
                                AppSpacing.lg,
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
                                  _remove(context, notification),
                              background: _buildDismissBackground(),
                              child: NotificationTile(
                                notification: notification,
                                onTap: () =>
                                    _service.markRead(notification.id),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool hasUnread) {
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
                  onPressed: _service.markAllRead,
                  child: Text(
                    AppStrings.markAllRead,
                    style: AppTypography.buttonSmall.copyWith(
                      color: AppColors.accent,
                    ),
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
