// Grid of listing cards.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/listing_model.dart';
import 'listing_card.dart';

// Two-column sliver grid, meant to sit inside a CustomScrollView.
class ListingGrid extends StatelessWidget {
  const ListingGrid({
    super.key,
    required this.listings,
    required this.favoriteIds,
    this.onFavorite,
  });

  final List<ListingModel> listings;
  final Set<String> favoriteIds;
  final ValueChanged<ListingModel>? onFavorite;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      itemCount: listings.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        mainAxisExtent: AppSizes.listingCardHeight,
      ),
      itemBuilder: (context, index) {
        final listing = listings[index];
        return ListingCard(
          listing: listing,
          isFavorite: favoriteIds.contains(listing.id),
          onFavorite: () => onFavorite?.call(listing),
        );
      },
    );
  }
}
