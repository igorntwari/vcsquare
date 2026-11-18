// Prompt text followed by a link.
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'auth_text_button.dart';

class AuthLinkRow extends StatelessWidget {
  const AuthLinkRow({
    super.key,
    required this.prompt,
    required this.link,
    required this.onTap,
  });

  final String prompt;
  final String link;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          prompt,
          style: AppTypography.bodySmallRegular.copyWith(
            color: AppColors.textOnDarkSoft,
          ),
        ),
        AuthTextButton(label: link, onTap: onTap),
      ],
    );
  }
}
