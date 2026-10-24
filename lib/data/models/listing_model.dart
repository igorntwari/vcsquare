// Model representing a marketplace listing.
import 'user_model.dart';

enum ListingCondition { brandNew, likeNew, good, used, forParts }

// Look of the tag in the top-left corner of the listing photo.
enum ListingTagStyle { dark, accent, light }

class ListingModel {
  const ListingModel({
    required this.id,
    required this.title,
    required this.details,
    required this.priceRwf,
    required this.condition,
    required this.categoryId,
    required this.seller,
    required this.createdAt,
    required this.distanceKm,
    this.imagePath,
    this.tag,
    this.tagStyle = ListingTagStyle.dark,
    this.isFavorited = false,
  });

  final String id;
  final String title;

  // Short spec line under the title, e.g. "8GB RAM • 256GB SSD".
  final String details;

  // Asking price in Rwandan francs.
  final int priceRwf;
  final ListingCondition condition;
  final String categoryId;
  final UserModel seller;
  final DateTime createdAt;

  // Distance from the buyer's usual campus spot, used for sorting.
  final double distanceKm;
  final String? imagePath;

  // Pickup or source label over the photo, e.g. "Kigali Pickup".
  final String? tag;
  final ListingTagStyle tagStyle;

  // Whether the current user had saved it when the market loaded.
  final bool isFavorited;
}
