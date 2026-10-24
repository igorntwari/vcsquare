// Post text with an optional bold lead-in.
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class PostBodyText extends StatelessWidget {
  const PostBodyText({super.key, required this.body, this.title});

  final String body;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
        children: [
          if (title != null)
            TextSpan(text: '${title!} ', style: AppTypography.bodyLargeStrong),
          TextSpan(text: body),
        ],
      ),
    );
  }
}
