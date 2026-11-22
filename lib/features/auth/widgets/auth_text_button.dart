// Underlined link for the navy sign-in screens.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class AuthTextButton extends StatelessWidget {
  const AuthTextButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSizes.tapTarget),
          child: Center(
            widthFactor: 1,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textOnDark,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.linkUnderlineOnDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
