// Small in-feed poll with one changeable vote per signed-in member.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/post_poll.dart';
import '../providers/home_providers.dart';

class PollCard extends ConsumerWidget {
  const PollCard({
    super.key,
    required this.postId,
    required this.poll,
    required this.initialCounts,
    this.selectedOption,
    this.onVote,
  });

  final String postId;
  final PostPoll poll;
  final Map<String, int> initialCounts;
  final String? selectedOption;
  final ValueChanged<String>? onVote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counts =
        ref.watch(postPollCountsProvider(postId)).value ?? initialCounts;
    final total = counts.values.fold<int>(0, (sum, count) => sum + count);
    final showResults = selectedOption != null && total > 0;

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
                  if (showResults) ...[
                    Text(
                      '${counts[option] ?? 0} · ${AppStrings.pollOptionPercent(((counts[option] ?? 0) * 100 / total).round())}',
                      style: AppTypography.label,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  if (selectedOption == option)
                    const Icon(Icons.check_circle, size: 18),
                ],
              ),
            ),
          ),
        if (selectedOption != null)
          Text(
            showResults
                ? '${AppStrings.pollVoteRecorded} · ${AppStrings.pollVoteCount(total)}'
                : AppStrings.pollVoteRecorded,
            style: AppTypography.bodySmall,
          ),
      ],
    );
  }
}
