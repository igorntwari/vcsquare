// Small in-feed poll with one changeable vote per signed-in member.
import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/post_poll.dart';

class PollCard extends StatelessWidget {
  const PollCard({
    super.key,
    required this.poll,
    this.selectedOption,
    this.onVote,
  });

  final PostPoll poll;
  final String? selectedOption;
  final ValueChanged<String>? onVote;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(poll.question, style: AppTypography.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        for (final option in poll.options)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: OutlinedButton(
              onPressed: onVote == null ? null : () => onVote!(option),
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                foregroundColor: selectedOption == option
                    ? AppColors.primary
                    : AppColors.textPrimary,
                side: BorderSide(
                  color: selectedOption == option
                      ? AppColors.primary
                      : AppColors.divider,
                ),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(option)),
                  if (selectedOption == option)
                    const Icon(Icons.check_circle, size: 18),
                ],
              ),
            ),
          ),
        if (selectedOption != null)
          Text(
            AppStrings.pollVoteRecorded,
            style: AppTypography.bodySmall,
          ),
      ],
    );
  }
}
