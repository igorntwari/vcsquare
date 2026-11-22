// Detail page for a verified campus account.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/official_handle_model.dart';
import '../../../shared/widgets/badges/verified_badge.dart';
import '../../../shared/widgets/buttons/follow_join_button.dart';

class OfficialHandleDetailScreen extends StatefulWidget {
  const OfficialHandleDetailScreen({
    super.key,
    required this.handle,
    required this.isFollowing,
    this.onFollow,
  });

  final OfficialHandleModel handle;
  final bool isFollowing;
  final VoidCallback? onFollow;

  @override
  State<OfficialHandleDetailScreen> createState() =>
      _OfficialHandleDetailScreenState();
}

class _OfficialHandleDetailScreenState
    extends State<OfficialHandleDetailScreen> {
  late bool _isFollowing = widget.isFollowing;

  @override
  Widget build(BuildContext context) {
    final handle = widget.handle;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.topBarBackground,
        foregroundColor: AppColors.textOnDark,
        title: Text(
          AppStrings.officialAccountDetailsTitle,
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
          Container(
            width: AppSizes.iconCircleMd,
            height: AppSizes.iconCircleMd,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              handle.icon,
              size: AppSizes.iconMd,
              color: AppColors.textOnDark,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            handle.name,
            style: AppTypography.headingLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            handle.handle,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const VerifiedBadge(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            handle.category,
            style: AppTypography.overline.copyWith(color: AppColors.success),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            handle.description,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: FollowJoinButton(
            label: AppStrings.follow,
            activeLabel: AppStrings.following,
            isActive: _isFollowing,
            style: FollowJoinStyle.prominent,
            icon: Icons.add,
            expand: true,
            onPressed: () {
              setState(() => _isFollowing = !_isFollowing);
              widget.onFollow?.call();
            },
          ),
        ),
      ),
    );
  }
}
