// Card for a campus community or club.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/community_model.dart';
import '../../../shared/widgets/avatars/user_avatar.dart';
import '../../../shared/widgets/buttons/follow_join_button.dart';
import '../../../shared/widgets/cards/app_card.dart';
import '../../../shared/widgets/chips/status_tag.dart';

class CommunityCard extends StatelessWidget {
  const CommunityCard({
    super.key,
    required this.community,
    required this.isJoined,
    this.onJoin,
  });

  final CommunityModel community;
  final bool isJoined;
  final VoidCallback? onJoin;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCover(),
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
                          community.name,
                          style: AppTypography.headingMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        StatusTag(
                          label: community.tag,
                          backgroundColor: AppColors.chipBackground,
                          foregroundColor: AppColors.textPrimary,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      community.description,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildAvatarPile(),
                        const SizedBox(width: AppSpacing.xs),
                        Flexible(
                          child: Text(
                            AppStrings.activeMembers(community.memberCount),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Container(
                          width: AppSizes.activityDot,
                          height: AppSizes.activityDot,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Flexible(
                          child: Text(
                            community.activity,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              FollowJoinButton(
                label: AppStrings.join,
                activeLabel: AppStrings.joined,
                isActive: isJoined,
                style: FollowJoinStyle.prominent,
                icon: Icons.group_add_outlined,
                onPressed: onJoin,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCover() {
    final placeholder = Container(
      color: AppColors.surfaceMuted,
      child: const Icon(
        Icons.groups,
        size: AppSizes.iconMd,
        color: AppColors.iconMuted,
      ),
    );
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
      child: SizedBox.square(
        dimension: AppSizes.communityImage,
        child: community.imagePath == null
            ? placeholder
            : Image.asset(
                community.imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => placeholder,
              ),
      ),
    );
  }

  // Up to three overlapping member avatars with a white ring.
  Widget _buildAvatarPile() {
    final members = community.members.take(3).toList();
    const step = AppSizes.avatarXxs - AppSpacing.sm;
    return SizedBox(
      width: AppSizes.avatarXxs + step * (members.length - 1),
      height: AppSizes.avatarXxs,
      child: Stack(
        children: [
          for (var i = 0; i < members.length; i++)
            Positioned(
              left: step * i,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.surface,
                    width: AppSizes.borderThin,
                  ),
                ),
                child: UserAvatar(
                  size: AppSizes.avatarXxs,
                  imagePath: members[i].avatarPath,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
