// Chip showing the listing a chat is about.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/listing_model.dart';

// Thumbnail, title, price and pickup spot. Optionally a "View" link.
class ListingPreviewChip extends StatelessWidget {
  const ListingPreviewChip({
    super.key,
    required this.listing,
    this.backgroundColor = AppColors.surfaceMuted,
    this.onView,
  });

  final ListingModel listing;
  final Color backgroundColor;

  // Shows a "View" link on the right when set.
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    final thumbPlaceholder = Container(
      color: AppColors.chipBackground,
      child: const Icon(
        Icons.image_outlined,
        size: AppSizes.iconSm,
        color: AppColors.iconMuted,
      ),
    );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.sm)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(AppRadius.sm)),
            child: SizedBox.square(
              dimension: AppSizes.listingThumb,
              child: listing.imagePath == null
                  ? thumbPlaceholder
                  : Image.asset(
                      listing.imagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => thumbPlaceholder,
                    ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        listing.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.label.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      Formatters.priceRwf(listing.priceRwf),
                      style: AppTypography.buttonSmall.copyWith(
                        color: AppColors.price,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: AppSizes.iconXs,
                      color: AppColors.iconMuted,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        '${AppStrings.pickupPrefix} ${listing.tag ?? ''}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onView != null) ...[
            const SizedBox(width: AppSpacing.sm),
            TextButton(
              onPressed: onView,
              child: Text(
                AppStrings.viewListing,
                style: AppTypography.label.copyWith(color: AppColors.accent),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
