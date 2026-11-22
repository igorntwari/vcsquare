// Top app bar used across screens.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../avatars/user_avatar.dart';
import '../navigation/bottom_nav_bar.dart';
import '../navigation/main_shell.dart';

// Navy header with the ALU crest, screen title, notifications and avatar.
class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.avatarImagePath,
    this.onNotificationsTap,
    this.onProfileTap,
  });

  final String title;
  final String? avatarImagePath;
  // Defaults to opening the notifications inbox.
  final VoidCallback? onNotificationsTap;
  // Defaults to switching to the Profile tab.
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ColoredBox(
        color: AppColors.topBarBackground,
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: AppSizes.topBarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  Image.asset(
                    AppAssets.aluBadge,
                    width: AppSizes.crest,
                    height: AppSizes.crest,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.virtualCommunity,
                          style: AppTypography.overline.copyWith(
                            color: AppColors.accent,
                          ),
                        ),
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.headingMedium.copyWith(
                            color: AppColors.textOnDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox.square(
                    dimension: AppSizes.tapTarget,
                    child: IconButton(
                      tooltip: AppStrings.notifications,
                      onPressed:
                          onNotificationsTap ??
                          NotificationService.instance.openInbox,
                      padding: EdgeInsets.zero,
                      icon: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(
                            Icons.notifications_none,
                            size: AppSizes.iconLg,
                            color: AppColors.textOnDark,
                          ),
                          // Red dot while any notification is unread.
                          Positioned(
                            top: 0,
                            right: 0,
                            child: ValueListenableBuilder(
                              valueListenable:
                                  NotificationService.instance.notifications,
                              builder: (context, notifications, _) {
                                if (notifications.every((n) => n.isRead)) {
                                  return const SizedBox.shrink();
                                }
                                return Container(
                                  width: AppSizes.statusDot,
                                  height: AppSizes.statusDot,
                                  decoration: const BoxDecoration(
                                    color: AppColors.accent,
                                    shape: BoxShape.circle,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Semantics(
                    button: true,
                    label: AppStrings.profile,
                    child: GestureDetector(
                      onTap:
                          onProfileTap ??
                          () => MainShell.selectTab(
                            context,
                            BottomNavBar.profileIndex,
                          ),
                      child: SizedBox.square(
                        dimension: AppSizes.tapTarget,
                        child: Center(
                          child: UserAvatar(
                            size: AppSizes.avatarSm,
                            imagePath: avatarImagePath,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
