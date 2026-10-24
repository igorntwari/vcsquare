// Bottom navigation bar for the main tabs.
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../badges/count_badge.dart';

// Frosted bar with five tabs. The active tab is a red circle with a white icon.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.messagesBadgeCount = 0,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final int messagesBadgeCount;

  static const int messagesIndex = 3;

  static const List<(IconData, String)> _items = [
    (Icons.home_outlined, AppStrings.navHome),
    (Icons.storefront_outlined, AppStrings.navMarket),
    (Icons.explore_outlined, AppStrings.navExplore),
    (Icons.send_outlined, AppStrings.navMessages),
    (Icons.person_outline, AppStrings.navProfile),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(boxShadow: AppShadows.navBar),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: ColoredBox(
            color: AppColors.navBarBackground,
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: AppSizes.navBarHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      for (var i = 0; i < _items.length; i++)
                        Expanded(child: _buildItem(i)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    final (icon, label) = _items[index];
    final isActive = index == currentIndex;
    // No badge on the tab you are already looking at.
    final badgeCount = index == messagesIndex && !isActive
        ? messagesBadgeCount
        : 0;

    Widget iconWidget = Icon(
      icon,
      size: AppSizes.iconMd,
      color: isActive ? AppColors.textOnDark : AppColors.iconMuted,
    );
    if (index == messagesIndex) {
      // Figma uses a paper plane pointing up-left: tilt the send arrow up,
      // then mirror it.
      iconWidget = Transform.flip(
        flipX: true,
        child: Transform.rotate(angle: -math.pi / 4, child: iconWidget),
      );
    }
    if (badgeCount > 0) {
      iconWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            top: -AppSpacing.xs,
            right: -AppSpacing.sm,
            child: CountBadge(count: badgeCount),
          ),
        ],
      );
    }

    final content = isActive
        ? Container(
            width: AppSizes.navActiveCircle,
            height: AppSizes.navActiveCircle,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
              boxShadow: AppShadows.accentGlow,
            ),
            child: Center(child: iconWidget),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.visible,
                softWrap: false,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          );

    return Semantics(
      button: true,
      selected: isActive,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: () => onTap(index),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: AppSizes.navItemMinWidth,
          ),
          child: Center(child: content),
        ),
      ),
    );
  }
}
