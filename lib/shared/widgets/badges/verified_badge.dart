// Badge marking a verified account.
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../chips/status_tag.dart';

class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const StatusTag(
      label: AppStrings.verified,
      icon: Icons.verified,
      backgroundColor: AppColors.greenSurface,
      foregroundColor: AppColors.success,
    );
  }
}
