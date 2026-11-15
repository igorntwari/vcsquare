// Sample-data listings. Saved listings are kept in memory.
import '../../dummy/dummy_categories.dart';
import '../../dummy/dummy_listings.dart';
import '../../dummy/dummy_pickup_hubs.dart';
import '../../dummy/dummy_viewer_state.dart';
import '../../models/category_model.dart';
import '../../models/listing_model.dart';
import '../../models/pickup_hub_model.dart';
import 'listings_repository.dart';

class SampleListingsRepository implements ListingsRepository {
  final Set<String> _savedListingIds = {...dummySavedListingIds};

  @override
  Future<List<ListingModel>> fetchListings() async => List.of(dummyListings);

  @override
  Future<List<ListingModel>> fetchListingsBySeller(String sellerId) async =>
      dummyListings.where((listing) => listing.seller.id == sellerId).toList();

  @override
  Future<List<CategoryModel>> fetchCategories() async => dummyCategories;

  @override
  Future<List<PickupHubModel>> fetchPickupHubs() async => dummyPickupHubs;

  @override
  Future<Set<String>> fetchSavedListingIds(String userId) async =>
      {..._savedListingIds};

  @override
  Future<void> setSaved({
    required String userId,
    required String listingId,
    required bool saved,
  }) async {
    saved ? _savedListingIds.add(listingId) : _savedListingIds.remove(listingId);
  }
}
