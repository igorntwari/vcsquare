// Marketplace listings, categories, pickup hubs and saved listings.
import '../../models/category_model.dart';
import '../../models/listing_draft_model.dart';
import '../../models/listing_model.dart';
import '../../models/pickup_hub_model.dart';

abstract interface class ListingsRepository {
  // Newest first. The Market screen filters and re-sorts locally.
  Future<List<ListingModel>> fetchListings();

  Future<List<ListingModel>> fetchListingsBySeller(String sellerId);

  Future<String> createListing(ListingModel listing);

  Future<void> updateListing(ListingModel listing);

  Future<void> deleteListing(String listingId);

  Future<List<ListingDraftModel>> fetchDrafts(String userId);

  Future<String> saveDraft({
    required String userId,
    required ListingDraftModel draft,
  });

  Future<void> deleteDraft({required String userId, required String draftId});

  // In display order.
  Future<List<CategoryModel>> fetchCategories();

  // In display order.
  Future<List<PickupHubModel>> fetchPickupHubs();

  Future<Set<String>> fetchSavedListingIds(String userId);

  Future<void> setSaved({
    required String userId,
    required String listingId,
    required bool saved,
  });
}