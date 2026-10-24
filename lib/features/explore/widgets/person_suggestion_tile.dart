// Tile suggesting a person to follow.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/peer_suggestion_model.dart';
import '../../../shared/widgets/avatars/online_badge.dart';
import '../../../shared/widgets/avatars/user_avatar.dart';
import '../../../shared/widgets/cards/app_card.dart';
import '../../../shared/widgets/chips/status_tag.dart';

class PersonSuggestionTile extends StatelessWidget {
  const PersonSuggestionTile({
    super.key,
    required this.suggestion,
    required this.isRequested,
    this.onConnect,
  });

  final PeerSuggestionModel suggestion;
  final bool isRequested;
  final VoidCallback? onConnect;

  @override
  Widget build(BuildContext context) {
    final user = suggestion.user;

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              UserAvatar(size: AppSizes.avatarXl, imagePath: user.avatarPath),
              if (user.isOnline)
                const Positioned(right: 0, bottom: 0, child: OnlineBadge()),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xxs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      user.name,
                      style: AppTypography.headingMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    StatusTag(
                      label: suggestion.program,
                      backgroundColor: AppColors.chipBackground,
                      foregroundColor: AppColors.textSecondary,
                    ),
                  ],
                ),
                Text(
                  suggestion.focus,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(
                      Icons.people_outline,
                      size: AppSizes.iconSm,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Flexible(
                      child: Text(
                        AppStrings.mutualPeers(
                          suggestion.mutualCount,
                          suggestion.sharedInterest,
                        ),
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            tooltip: isRequested
                ? AppStrings.requestSent
                : '${AppStrings.connect} ${user.name}',
            onPressed: onConnect,
            style: IconButton.styleFrom(
              backgroundColor: isRequested
                  ? AppColors.greenSurface
                  : AppColors.surfaceMuted,
              fixedSize: const Size.square(AppSizes.connectButton),
              minimumSize: const Size.square(AppSizes.connectButton),
            ),
            icon: Icon(
              isRequested ? Icons.check : Icons.person_add_alt_1_outlined,
              size: AppSizes.iconSm,
              color: isRequested ? AppColors.success : AppColors.iconDefault,
            ),
          ),
        ],
      ),
    );
  }
}
