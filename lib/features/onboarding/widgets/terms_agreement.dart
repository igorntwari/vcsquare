// Checkbox row agreeing to the campus terms on the login screen.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class TermsAgreement extends StatefulWidget {
  const TermsAgreement({super.key});

  @override
  State<TermsAgreement> createState() => _TermsAgreementState();
}

class _TermsAgreementState extends State<TermsAgreement> {
  bool _accepted = true;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTypography.bodySmall.copyWith(
      color: AppColors.textOnDarkFaint,
    );
    final linkStyle = textStyle.copyWith(
      color: AppColors.textOnDark,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.linkUnderlineOnDark,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _accepted = !_accepted),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSizes.iconSm,
            height: AppSizes.iconSm,
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: const BorderRadius.all(
                Radius.circular(AppRadius.xs),
              ),
              border: Border.all(
                color: AppColors.primary,
                width: AppSizes.borderThin,
              ),
            ),
            child: _accepted
                ? const Icon(
                    Icons.check,
                    size: AppSizes.iconXs,
                    color: AppColors.primary,
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: textStyle,
                children: [
                  const TextSpan(text: AppStrings.termsPrefix),
                  TextSpan(text: AppStrings.campusHonorCode, style: linkStyle),
                  const TextSpan(text: ', '),
                  TextSpan(
                    text: AppStrings.acceptableUsePolicy,
                    style: linkStyle,
                  ),
                  const TextSpan(text: ', and '),
                  TextSpan(text: AppStrings.privacyPolicy, style: linkStyle),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
