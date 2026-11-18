// Model representing a marketplace listing.
import 'firestore_helpers.dart';
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
    List<String>? photoUrls,
    this.pickupHubId,
    this.negotiable = true,
    this.status = 'active',
    this.tag,
    this.tagStyle = ListingTagStyle.dark,
  }) : photoUrls = photoUrls ?? const [if (imagePath != null) imagePath];

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
  final List<String> photoUrls;
  final String? pickupHubId;
  final bool negotiable;
  final String status;

  // Pickup or source label over the photo, e.g. "Kigali Pickup".
  final String? tag;
  final ListingTagStyle tagStyle;

  // listings/{id}. [seller] is looked up from sellerId.
  factory ListingModel.fromFirestore(
    String id,
    FirestoreMap data, {
    required UserModel seller,
  }) => ListingModel(
    id: id,
    title: readString(data['title']),
    details: readString(data['details']),
    priceRwf: readInt(data['priceRwf']),
    condition: readEnum(
      ListingCondition.values,
      data['condition'],
      ListingCondition.used,
    ),
    categoryId: readString(data['categoryId']),
    seller: seller,
    createdAt: readDate(data['createdAt']),
    distanceKm: (data['distanceKm'] as num?)?.toDouble() ?? 0,
    imagePath: data['imagePath'] as String?,
    photoUrls:
        (data['photoUrls'] as List<dynamic>?)?.whereType<String>().toList(
          growable: false,
        ) ??
        [if (data['imagePath'] is String) data['imagePath'] as String],
    pickupHubId: data['pickupHubId'] as String?,
    negotiable: data['negotiable'] as bool? ?? true,
    status: data['status'] as String? ?? 'active',
    tag: data['tag'] as String?,
    tagStyle: readEnum(
      ListingTagStyle.values,
      data['tagStyle'],
      ListingTagStyle.dark,
    ),
  );

  FirestoreMap toFirestore() => {
    'title': title,
    'details': details,
    'priceRwf': priceRwf,
    'condition': condition.name,
    'categoryId': categoryId,
    'sellerId': seller.id,
    'createdAt': writeDate(createdAt),
    'distanceKm': distanceKm,
    'imagePath': imagePath,
    'photoUrls': photoUrls,
    'pickupHubId': pickupHubId,
    'negotiable': negotiable,
    'status': status,
    'tag': tag,
    'tagStyle': tagStyle.name,
  };
}
