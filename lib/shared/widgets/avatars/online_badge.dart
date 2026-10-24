// Dot indicator showing a user is online.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';

class OnlineBadge extends StatelessWidget {
  const OnlineBadge({super.key, this.size = AppSizes.onlineBadge});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.online,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.surface,
          width: AppSizes.borderThick,
        ),
      ),
    );
  }
}
