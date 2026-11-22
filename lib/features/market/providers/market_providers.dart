// Data for the Market and Sell screens.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/category_model.dart';
import '../../../data/models/listing_model.dart';
import '../../../data/models/pickup_hub_model.dart';
import '../../../data/repositories/repository_providers.dart';

typedef MarketData = ({
  List<ListingModel> listings,
  List<ListingModel> myListings,
  List<CategoryModel> categories,
  // Listings the signed-in user has saved.
  Set<String> savedListingIds,
});

final marketProvider = FutureProvider<MarketData>((ref) async {
  final userId = await ref.watch(currentUserIdProvider.future);
  final repo = ref.watch(listingsRepositoryProvider);

  final (listings, myListings, categories, saved) = await (
    repo.fetchListings(),
    userId == null
        ? Future.value(<ListingModel>[])
        : repo.fetchListingsBySeller(userId),
    repo.fetchCategories(),
    userId == null
        ? Future.value(<String>{})
        : repo.fetchSavedListingIds(userId),
  ).wait;
  return (
    listings: listings,
    myListings: myListings,
    categories: categories,
    savedListingIds: saved,
  );
});

typedef SellFormOptions = ({
  List<CategoryModel> categories,
  List<PickupHubModel> pickupHubs,
});

final sellFormOptionsProvider = FutureProvider<SellFormOptions>((ref) async {
  final repo = ref.watch(listingsRepositoryProvider);
  final (categories, hubs) = await (
    repo.fetchCategories(),
    repo.fetchPickupHubs(),
  ).wait;
  return (categories: categories, pickupHubs: hubs);
});
