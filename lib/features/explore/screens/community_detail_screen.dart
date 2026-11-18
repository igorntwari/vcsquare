// Detail page for a campus community.
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
import '../../../shared/widgets/chips/status_tag.dart';
import '../../../shared/widgets/media/app_image.dart';

class CommunityDetailScreen extends StatefulWidget {
  const CommunityDetailScreen({
    super.key,
    required this.community,
    required this.isJoined,
    this.onJoin,
  });

  final CommunityModel community;
  final bool isJoined;
  final VoidCallback? onJoin;

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen> {
  late bool _isJoined = widget.isJoined;

  @override
  Widget build(BuildContext context) {
    final community = widget.community;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.topBarBackground,
        foregroundColor: AppColors.textOnDark,
        title: Text(
          AppStrings.communityDetailsTitle,
          style: AppTypography.headingMedium.copyWith(
            color: AppColors.textOnDark,
          ),
        ),
        leading: IconButton(
          tooltip: AppStrings.back,
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildCover(community),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text(
                  community.name,
                  style: AppTypography.headingLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              StatusTag(
                label: community.tag,
                backgroundColor: AppColors.chipBackground,
                foregroundColor: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            community.description,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            community.activity,
            style: AppTypography.titleLarge.copyWith(color: AppColors.success),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.activeMembers(community.memberCount),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (community.members.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final member in community.members)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UserAvatar(
                        size: AppSizes.avatarXs,
                        imagePath: member.avatarPath,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        member.name,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: FollowJoinButton(
            label: AppStrings.join,
            activeLabel: AppStrings.joined,
            isActive: _isJoined,
            style: FollowJoinStyle.prominent,
            icon: Icons.group_add_outlined,
            expand: true,
            onPressed: () {
              setState(() => _isJoined = !_isJoined);
              widget.onJoin?.call();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCover(CommunityModel community) {
    final placeholder = const ColoredBox(
      color: AppColors.surfaceMuted,
      child: Icon(Icons.groups, color: AppColors.iconMuted),
    );
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: community.imagePath == null
            ? placeholder
            : AppImage(
                community.imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => placeholder,
              ),
      ),
    );
  }
}
