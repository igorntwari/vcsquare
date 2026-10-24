// Section for adding listing photos.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

// Large cover photo with two small photos beside it, then three "add" slots.
class PhotoUploadSection extends StatelessWidget {
  const PhotoUploadSection({
    super.key,
    required this.photos,
    this.onAdd,
    this.onRemove,
  });

  // Asset paths; the first one is the cover.
  final List<String> photos;
  final VoidCallback? onAdd;
  final ValueChanged<int>? onRemove;

  @override
  Widget build(BuildContext context) {
    const smallHeight = (AppSizes.coverPhotoHeight - AppSpacing.md) / 2;

    return Column(
      children: [
        SizedBox(
          height: AppSizes.coverPhotoHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: photos.isEmpty
                    ? _buildAddSlot(Icons.add_a_photo_outlined, AppStrings.coverPhoto)
                    : _buildPhoto(0, isCover: true),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: smallHeight,
                      width: double.infinity,
                      child: photos.length > 1 ? _buildPhoto(1) : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: smallHeight,
                      width: double.infinity,
                      child: photos.length > 2 ? _buildPhoto(2) : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildAddSlot(Icons.add_a_photo_outlined, AppStrings.addAngle),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildAddSlot(Icons.receipt_long_outlined, AppStrings.receiptBox),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildAddSlot(Icons.add, AppStrings.extraPhoto),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhoto(int index, {bool isCover = false}) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(photos[index], fit: BoxFit.cover),
          if (isCover) ...[
            const DecoratedBox(
              decoration: BoxDecoration(gradient: AppColors.photoScrim),
            ),
            Positioned(
              top: AppSpacing.sm,
              left: AppSpacing.sm,
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
                      Icons.star,
                      size: AppSizes.iconXs,
                      color: AppColors.textOnDark,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      AppStrings.coverPhoto,
                      style: AppTypography.overline.copyWith(
                        color: AppColors.textOnDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.sm,
              bottom: AppSpacing.sm,
              child: Row(
                children: [
                  const Icon(
                    Icons.drag_indicator,
                    size: AppSizes.iconXs,
                    color: AppColors.textOnDarkSoft,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    AppStrings.holdToReorder,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textOnDarkSoft,
                    ),
                  ),
                ],
              ),
            ),
          ],
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: Material(
              color: AppColors.photoActionBackground,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => onRemove?.call(index),
                child: const SizedBox.square(
                  dimension: AppSizes.radioSize + AppSpacing.xs,
                  child: Icon(
                    Icons.close,
                    size: AppSizes.iconXs,
                    color: AppColors.textOnDark,
                    semanticLabel: AppStrings.deletePhoto,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddSlot(IconData icon, String label) {
    return Material(
      color: AppColors.surfaceMuted,
      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: photos.length < AppSizes.maxListingPhotos ? onAdd : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: AppSizes.settingsIconBox,
                height: AppSizes.settingsIconBox,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.card,
                ),
                child: Icon(icon, size: AppSizes.iconSm, color: AppColors.iconDefault),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTypography.chip.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
