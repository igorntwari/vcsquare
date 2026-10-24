// Section title with an optional trailing action.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

// Optional uppercase kicker above a heading, with an optional text link
// ("See directory ›") or any custom widget on the right.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.kicker,
    this.kickerColor = AppColors.textMuted,
    this.actionLabel,
    this.actionColor = AppColors.accent,
    this.onAction,
    this.trailing,
  });

  final String title;
  final String? kicker;
  final Color kickerColor;
  final String? actionLabel;
  final Color actionColor;
  final VoidCallback? onAction;

  // Used instead of the text link when set.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (kicker != null)
                Text(
                  kicker!,
                  style: AppTypography.overline.copyWith(color: kickerColor),
                ),
              Text(
                title,
                style: AppTypography.headingMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null)
          trailing!
        else if (actionLabel != null)
          InkWell(
            onTap: onAction,
            borderRadius: const BorderRadius.all(
              Radius.circular(AppRadius.pill),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel!,
                    style: AppTypography.label.copyWith(color: actionColor),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: AppSizes.iconSm,
                    color: actionColor,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
