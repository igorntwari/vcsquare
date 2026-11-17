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
  final List<ListingModel> _createdListings = [];

  @override
  Future<List<ListingModel>> fetchListings() async => [
    ..._createdListings.reversed,
    ...dummyListings,
  ];

  @override
  Future<List<ListingModel>> fetchListingsBySeller(String sellerId) async => [
    ..._createdListings,
    ...dummyListings,
  ].where((listing) => listing.seller.id == sellerId).toList();

  @override
  Future<String> createListing(ListingModel listing) async {
    final id = 'sample-${DateTime.now().microsecondsSinceEpoch}';
    _createdListings.add(
      ListingModel(
        id: id,
        title: listing.title,
        details: listing.details,
        priceRwf: listing.priceRwf,
        condition: listing.condition,
        categoryId: listing.categoryId,
        seller: listing.seller,
        createdAt: listing.createdAt,
        distanceKm: listing.distanceKm,
        imagePath: listing.imagePath,
        tag: listing.tag,
        tagStyle: listing.tagStyle,
      ),
    );
    return id;
  }

  @override
  Future<List<CategoryModel>> fetchCategories() async => dummyCategories;

  @override
  Future<List<PickupHubModel>> fetchPickupHubs() async => dummyPickupHubs;

  @override
  Future<Set<String>> fetchSavedListingIds(String userId) async => {
    ..._savedListingIds,
  };

  @override
  Future<void> setSaved({
    required String userId,
    required String listingId,
    required bool saved,
  }) async {
    saved
        ? _savedListingIds.add(listingId)
        : _savedListingIds.remove(listingId);
  }
}
