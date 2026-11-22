// Compact listing result shown by Explore search.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/listing_model.dart';
import '../../../shared/widgets/cards/app_card.dart';
import '../../../shared/widgets/media/app_image.dart';

class ExploreListingResultTile extends StatelessWidget {
  const ExploreListingResultTile({super.key, required this.listing});

  final ListingModel listing;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(AppRadius.sm)),
            child: SizedBox.square(
              dimension: AppSizes.communityImage,
              child: listing.imagePath == null
                  ? const ColoredBox(
                      color: AppColors.surfaceMuted,
                      child: Icon(
                        Icons.image_outlined,
                        color: AppColors.iconMuted,
                      ),
                    )
                  : AppImage(
                      listing.imagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const ColoredBox(
                        color: AppColors.surfaceMuted,
                        child: Icon(
                          Icons.image_outlined,
                          color: AppColors.iconMuted,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listing.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  Formatters.priceRwf(listing.priceRwf),
                  style: AppTypography.price.copyWith(color: AppColors.price),
                ),
                Text(
                  listing.seller.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
