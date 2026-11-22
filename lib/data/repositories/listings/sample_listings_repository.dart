// Sample-data listings. Saved listings are kept in memory.
import '../../dummy/dummy_categories.dart';
import '../../dummy/dummy_listings.dart';
import '../../dummy/dummy_pickup_hubs.dart';
import '../../dummy/dummy_viewer_state.dart';
import '../../models/category_model.dart';
import '../../models/listing_draft_model.dart';
import '../../models/listing_model.dart';
import '../../models/pickup_hub_model.dart';
import 'listings_repository.dart';

class SampleListingsRepository implements ListingsRepository {
  final Set<String> _savedListingIds = {...dummySavedListingIds};
  final List<ListingModel> _createdListings = [];
  final Map<String, ListingModel> _updatedListings = {};
  final Set<String> _deletedListingIds = {};
  final Map<String, ListingDraftModel> _drafts = {};

  @override
  Future<List<ListingModel>> fetchListings() async => [
    ..._createdListings.reversed,
    for (final listing in dummyListings)
      if (!_deletedListingIds.contains(listing.id))
        _updatedListings[listing.id] ?? listing,
  ];

  @override
  Future<List<ListingModel>> fetchListingsBySeller(String sellerId) async => [
    ..._createdListings,
    for (final listing in dummyListings)
      if (!_deletedListingIds.contains(listing.id))
        _updatedListings[listing.id] ?? listing,
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
        photoUrls: listing.photoUrls,
        pickupHubId: listing.pickupHubId,
        negotiable: listing.negotiable,
        status: listing.status,
        tag: listing.tag,
        tagStyle: listing.tagStyle,
      ),
    );
    return id;
  }

  @override
  Future<void> updateListing(ListingModel listing) async {
    final index = _createdListings.indexWhere((item) => item.id == listing.id);
    if (index >= 0) {
      _createdListings[index] = listing;
      return;
    }
    _updatedListings[listing.id] = listing;
  }

  @override
  Future<void> deleteListing(String listingId) async {
    _createdListings.removeWhere((item) => item.id == listingId);
    _updatedListings.remove(listingId);
    _deletedListingIds.add(listingId);
    _savedListingIds.remove(listingId);
  }

  @override
  Future<List<ListingDraftModel>> fetchDrafts(String userId) async =>
      _drafts.values.toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

  @override
  Future<String> saveDraft({
    required String userId,
    required ListingDraftModel draft,
  }) async {
    final id = draft.id.isEmpty
        ? 'sample-draft-${DateTime.now().microsecondsSinceEpoch}'
        : draft.id;
    _drafts[id] = ListingDraftModel(
      id: id,
      title: draft.title,
      description: draft.description,
      priceText: draft.priceText,
      categoryId: draft.categoryId,
      condition: draft.condition,
      pickupHubId: draft.pickupHubId,
      negotiable: draft.negotiable,
      photoUrls: draft.photoUrls,
      updatedAt: draft.updatedAt,
    );
    return id;
  }

  @override
  Future<void> deleteDraft({
    required String userId,
    required String draftId,
  }) async {
    _drafts.remove(draftId);
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