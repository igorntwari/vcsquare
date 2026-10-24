// Bar prompting the user to start a new post.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/avatars/online_badge.dart';
import '../../../shared/widgets/avatars/user_avatar.dart';

class PostComposerBar extends StatelessWidget {
  const PostComposerBar({
    super.key,
    this.avatarImagePath,
    this.isOnline = true,
    this.onComposeTap,
    this.onAttachMediaTap,
    this.onCreatePollTap,
  });

  final String? avatarImagePath;
  final bool isOnline;
  final VoidCallback? onComposeTap;
  final VoidCallback? onAttachMediaTap;
  final VoidCallback? onCreatePollTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.composerHeight,
      child: Row(
        children: [
          Stack(
            children: [
              UserAvatar(size: AppSizes.avatarMd, imagePath: avatarImagePath),
              if (isOnline)
                const Positioned(right: 0, bottom: 0, child: OnlineBadge()),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Material(
              color: AppColors.composerFieldOnDark,
              shape: const StadiumBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onComposeTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Text(
                    AppStrings.composerHint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          _buildAction(
            Icons.image_outlined,
            AppStrings.attachMedia,
            onAttachMediaTap,
          ),
          _buildAction(Icons.bar_chart, AppStrings.createPoll, onCreatePollTap),
        ],
      ),
    );
  }

  // Small faded icon button on the right of the composer.
  Widget _buildAction(IconData icon, String tooltip, VoidCallback? onTap) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(
        width: AppSizes.iconButtonSm,
        height: AppSizes.iconButtonSm,
      ),
      style: IconButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
        ),
      ),
      icon: Icon(icon, size: AppSizes.iconSm, color: AppColors.textOnDarkFaint),
    );
  }
}
