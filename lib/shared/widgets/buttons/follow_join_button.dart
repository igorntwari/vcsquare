// Toggle button for following a user or joining a community.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

enum FollowJoinStyle {
  // Small red pill on post headers ("Join Club").
  compact,

  // Taller navy pill on Explore cards ("Follow", "Join").
  prominent,
}

// Turns into a green pill with a check ("Joined", "Following") when active.
class FollowJoinButton extends StatelessWidget {
  const FollowJoinButton({
    super.key,
    required this.label,
    required this.activeLabel,
    required this.isActive,
    this.style = FollowJoinStyle.compact,
    this.icon,
    this.expand = false,
    this.onPressed,
  });

  final String label;
  final String activeLabel;
  final bool isActive;
  final FollowJoinStyle style;

  // Leading icon while inactive (prominent style only).
  final IconData? icon;

  // Stretch to the full available width.
  final bool expand;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isProminent = style == FollowJoinStyle.prominent;
    final Color background;
    final Color foreground;
    if (isActive) {
      background = AppColors.greenSurface;
      foreground = AppColors.success;
    } else if (isProminent) {
      background = AppColors.primary;
      foreground = AppColors.textOnDark;
    } else {
      background = AppColors.redSurface;
      foreground = AppColors.accent;
    }
    final leadingIcon = isActive ? Icons.check : (isProminent ? icon : null);

    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          Icon(
            leadingIcon,
            size: isProminent ? AppSizes.iconSm : AppSizes.iconXs,
            color: foreground,
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
        Text(
          isActive ? activeLabel : label,
          style: (isProminent ? AppTypography.label : AppTypography.buttonSmall)
              .copyWith(color: foreground),
        ),
      ],
    );

    return Semantics(
      button: true,
      toggled: isActive,
      child: Material(
        color: background,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: isProminent
              ? SizedBox(
                  height: AppSizes.pillButtonHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: content,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  child: content,
                ),
        ),
      ),
    );
  }
}
