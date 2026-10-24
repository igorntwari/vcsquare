// Toggle button for following a user or joining a community.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

// Red pill ("Join Club") that turns into a green pill with a check ("Joined").
class FollowJoinButton extends StatelessWidget {
  const FollowJoinButton({
    super.key,
    required this.label,
    required this.activeLabel,
    required this.isActive,
    this.onPressed,
  });

  final String label;
  final String activeLabel;
  final bool isActive;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final foreground = isActive ? AppColors.success : AppColors.accent;

    return Semantics(
      button: true,
      toggled: isActive,
      child: Material(
        color: isActive ? AppColors.greenSurface : AppColors.redSurface,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isActive) ...[
                  Icon(Icons.check, size: AppSizes.iconXs, color: foreground),
                  const SizedBox(width: AppSpacing.xxs),
                ],
                Text(
                  isActive ? activeLabel : label,
                  style: AppTypography.buttonSmall.copyWith(color: foreground),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
