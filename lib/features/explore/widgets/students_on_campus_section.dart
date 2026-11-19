// Explore's "Students on campus" list.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../shared/widgets/feedback/app_snack_bar.dart';
import '../../../shared/widgets/layout/section_header.dart';
import '../providers/explore_providers.dart';
import 'student_tile.dart';

class StudentsOnCampusSection extends ConsumerWidget {
  const StudentsOnCampusSection({super.key, this.onOpenStudent});

  final ValueChanged<UserModel>? onOpenStudent;

  Future<void> _toggleFollow(
    BuildContext context,
    WidgetRef ref,
    String studentId,
    bool following,
  ) async {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return;
    try {
      await ref
          .read(followRepositoryProvider)
          .setFollowingStudent(
            userId: userId,
            studentId: studentId,
            following: following,
          );
    } catch (_) {
      if (context.mounted) showAppSnackBar(context, AppStrings.saveFailed);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider).value ?? const [];
    final followingIds = ref.watch(followingIdsProvider).value ?? const {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(
          kicker: AppStrings.onCampus,
          title: AppStrings.studentsOnCampus,
        ),
        const SizedBox(height: AppSpacing.sm),
        if (students.isEmpty)
          Text(
            AppStrings.noStudentsYet,
            style: AppTypography.bodySmallRegular.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        for (final student in students) ...[
          StudentTile(
            student: student,
            isFollowing: followingIds.contains(student.id),
            onFollow: () => _toggleFollow(
              context,
              ref,
              student.id,
              !followingIds.contains(student.id),
            ),
            onTap: () => onOpenStudent?.call(student),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
