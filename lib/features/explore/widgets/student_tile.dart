// A student in Explore's "Students on campus", with a Follow button.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/user_model.dart';
import '../../../shared/widgets/avatars/user_avatar.dart';
import '../../../shared/widgets/buttons/follow_join_button.dart';
import '../../../shared/widgets/cards/app_card.dart';

class StudentTile extends StatelessWidget {
  const StudentTile({
    super.key,
    required this.student,
    required this.isFollowing,
    this.onFollow,
    this.onTap,
  });

  final UserModel student;
  final bool isFollowing;
  final VoidCallback? onFollow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AppCard(
        child: Row(
          children: [
            UserAvatar(size: AppSizes.avatarLg, imagePath: student.avatarPath),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    student.handle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmallRegular.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            FollowJoinButton(
              label: AppStrings.follow,
              activeLabel: AppStrings.following,
              isActive: isFollowing,
              style: FollowJoinStyle.prominent,
              onPressed: onFollow,
            ),
          ],
        ),
      ),
    );
  }
}
