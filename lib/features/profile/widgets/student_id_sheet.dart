// Digital student ID card built from the signed-in student's profile.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/profile_model.dart';
import '../../../shared/widgets/avatars/user_avatar.dart';

// Navy card with photo, name, handle, programme, campus and the verified
// school email domain. Empty fields are left out.
class StudentIdSheet extends StatelessWidget {
  const StudentIdSheet({super.key, required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final user = profile.user;
    final rows = <(String, String)>[
      if (profile.program.isNotEmpty) (AppStrings.idProgram, profile.program),
      if (profile.campus.isNotEmpty) (AppStrings.idCampus, profile.campus),
      if (user.cohort case final cohort? when cohort.isNotEmpty)
        (AppStrings.idCohort, cohort),
      if (profile.emailDomain.isNotEmpty)
        (AppStrings.idVerifiedEmail, profile.emailDomain),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: const BoxDecoration(
            color: AppColors.topBarBackground,
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.studentIdCardTitle,
                style: AppTypography.label.copyWith(
                  color: AppColors.textOnDarkMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  UserAvatar(
                    size: AppSizes.avatarLg,
                    imagePath: user.avatarPath,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: AppTypography.headingMedium.copyWith(
                            color: AppColors.textOnDark,
                          ),
                        ),
                        Text(
                          user.handle,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textOnDarkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              for (final (label, value) in rows)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: AppSizes.idLabelWidth,
                        child: Text(
                          label,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textOnDarkMuted,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          value,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textOnDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
