// Rounded post photo with an optional location pill.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class PostPhoto extends StatelessWidget {
  const PostPhoto({super.key, required this.imagePath, this.caption});

  final String imagePath;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.sm)),
      child: SizedBox(
        height: AppSizes.postImageHeight,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              // Soft placeholder until the photo is added to assets/images/posts.
              errorBuilder: (_, _, _) => const ColoredBox(
                color: AppColors.imagePlaceholder,
                child: Icon(
                  Icons.image_outlined,
                  size: AppSizes.iconLg,
                  color: AppColors.iconMuted,
                ),
              ),
            ),
            if (caption != null)
              Positioned(
                left: AppSpacing.sm,
                bottom: AppSpacing.sm,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.imageCaptionBackground,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppRadius.pill),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: AppSizes.iconXs,
                        color: AppColors.textOnDark,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        caption!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textOnDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
