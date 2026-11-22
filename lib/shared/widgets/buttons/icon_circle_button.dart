// Round icon-only button.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';

// Filled circle with a centred icon, e.g. close, back or settings buttons.
// [size] is the circle; the tap target never drops below AppSizes.tapTarget.
class IconCircleButton extends StatelessWidget {
  const IconCircleButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.size = AppSizes.iconCircleMd,
    this.iconSize = AppSizes.iconSm,
    this.backgroundColor = AppColors.chipBackground,
    this.iconColor = AppColors.iconDefault,
  });

  final IconData icon;

  // Read by screen readers; always required for icon-only buttons.
  final String tooltip;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        fixedSize: Size.square(size),
        minimumSize: Size.square(size),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
      icon: Icon(icon, size: iconSize, color: iconColor),
    );
  }
}
