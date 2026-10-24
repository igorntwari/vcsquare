// Row of profile stats such as posts, listings and followers.
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';

// White ribbon with four counters. Listings is highlighted in red.
class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({
    super.key,
    required this.posts,
    required this.listings,
    required this.followers,
    required this.following,
  });

  final int posts;
  final int listings;
  final int followers;
  final int following;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        boxShadow: AppShadows.navBar,
      ),
      child: Row(
        children: [
          _buildStat(posts, AppStrings.statPosts),
          _buildStat(listings, AppStrings.statListings, highlight: true),
          _buildStat(followers, AppStrings.statFollowers),
          _buildStat(following, AppStrings.statFollowing),
        ],
      ),
    );
  }

  Widget _buildStat(int value, String label, {bool highlight = false}) {
    return Expanded(
      child: Semantics(
        label: '$value $label',
        excludeSemantics: true,
        child: Column(
          children: [
            Text(
              Formatters.compactCount(value),
              style: AppTypography.headingMedium.copyWith(
                color: highlight ? AppColors.accent : AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
