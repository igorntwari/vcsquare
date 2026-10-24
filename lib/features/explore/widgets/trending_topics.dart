// List of trending topics.
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/trending_topic_model.dart';

// Wrapping white pills: colored hashtag plus how busy it is.
class TrendingTopics extends StatelessWidget {
  const TrendingTopics({super.key, required this.topics, this.onTopicTap});

  final List<TrendingTopicModel> topics;
  final ValueChanged<TrendingTopicModel>? onTopicTap;

  // Hottest topic in red, then orange, navy and slate, repeating.
  static const List<Color> _tagColors = [
    AppColors.accent,
    AppColors.kickerWarm,
    AppColors.textPrimary,
    AppColors.textSecondary,
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (var i = 0; i < topics.length; i++)
          DecoratedBox(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
              boxShadow: AppShadows.card,
            ),
            child: Material(
              color: AppColors.surface,
              shape: const StadiumBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => onTopicTap?.call(topics[i]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        topics[i].tag,
                        style: AppTypography.label.copyWith(
                          color: _tagColors[i % _tagColors.length],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        topics[i].activity,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
