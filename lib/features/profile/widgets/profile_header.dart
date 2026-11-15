// Header with avatar, name and bio.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/profile_model.dart';
import '../../../shared/widgets/avatars/user_avatar.dart';
import '../../../shared/widgets/chips/status_tag.dart';

// Gradient cover, overlapping avatar with Student ID / Edit buttons, then
// name, verified email, tags, programme and bio.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.profile,
    this.onSettings,
    this.onStudentId,
    this.onEdit,
  });

  final ProfileModel profile;
  final VoidCallback? onSettings;
  final VoidCallback? onStudentId;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: AppSizes.profileCoverHeight,
          child: _buildCover(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSizes.profileCoverHeight - AppSizes.profileAvatarOverlap,
            AppSpacing.lg,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildAvatar(),
                  const Spacer(),
                  _buildActionButton(
                    icon: Icons.badge_outlined,
                    label: AppStrings.studentId,
                    background: AppColors.blueSurface,
                    foreground: AppColors.textPrimary,
                    onTap: onStudentId,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _buildActionButton(
                    icon: Icons.edit_outlined,
                    label: AppStrings.edit,
                    background: AppColors.primary,
                    foreground: AppColors.textOnDark,
                    onTap: onEdit,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xxs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    profile.user.name,
                    style: AppTypography.headingLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  StatusTag(
                    label: profile.emailDomain,
                    icon: Icons.verified,
                    backgroundColor: AppColors.greenSurface,
                    foregroundColor: AppColors.success,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  StatusTag(
                    label: profile.roleTag,
                    backgroundColor: AppColors.redSurface,
                    foregroundColor: AppColors.accent,
                  ),
                  StatusTag(
                    label: profile.campus,
                    backgroundColor: AppColors.chipBackground,
                    foregroundColor: AppColors.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  const Icon(
                    Icons.school_outlined,
                    size: AppSizes.iconSm,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      profile.program,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildBio(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCover() {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.profileCoverGradient),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.coverFade),
        ),
        Positioned(
          top: AppSpacing.md,
          right: AppSpacing.lg,
          child: IconButton(
            tooltip: AppStrings.accountSettings,
            onPressed: onSettings,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.coverButtonBackground,
              fixedSize: const Size.square(AppSizes.settingsIconBox),
              minimumSize: const Size.square(AppSizes.settingsIconBox),
            ),
            icon: const Icon(
              Icons.settings_outlined,
              size: AppSizes.iconSm,
              color: AppColors.textOnDark,
            ),
          ),
        ),
      ],
    );
  }

  // White-ringed avatar with a green "online" pulse badge.
  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          width: AppSizes.avatarXxl,
          height: AppSizes.avatarXxl,
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            boxShadow: AppShadows.navBar,
          ),
          child: UserAvatar(
            size: AppSizes.avatarXxl - AppSpacing.sm,
            imagePath: profile.user.avatarPath,
          ),
        ),
        if (profile.user.isOnline)
          Positioned(
            right: AppSpacing.xs,
            bottom: AppSpacing.xs,
            child: Container(
              width: AppSizes.profileStatusBadge,
              height: AppSizes.profileStatusBadge,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.online,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surface,
                  width: AppSizes.borderThick,
                ),
              ),
              child: Container(
                width: AppSizes.statusDot,
                height: AppSizes.statusDot,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color background,
    required Color foreground,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Material(
        color: background,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: AppSizes.profileActionHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: AppSizes.iconSm, color: foreground),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    label,
                    style: AppTypography.label.copyWith(color: foreground),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Bio text with the highlighted part (e.g. a club name) in bold navy.
  Widget _buildBio() {
    final baseStyle = AppTypography.bodyLarge.copyWith(
      color: AppColors.textSecondary,
    );
    final highlight = profile.bioHighlight;
    final index = highlight == null ? -1 : profile.bio.indexOf(highlight);
    if (index < 0) return Text(profile.bio, style: baseStyle);
    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: profile.bio.substring(0, index)),
          TextSpan(
            text: highlight,
            style: AppTypography.bodyLargeStrong.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          TextSpan(text: profile.bio.substring(index + highlight!.length)),
        ],
      ),
    );
  }
}
