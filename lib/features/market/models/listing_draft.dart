// Values collected by the sell form and shown in its listing preview.
import '../../../data/models/listing_model.dart';

class ListingDraft {
  const ListingDraft({
    required this.title,
    required this.description,
    required this.priceRwf,
    required this.categoryId,
    required this.categoryName,
    required this.condition,
    required this.pickupHubId,
    required this.pickupHubName,
    required this.negotiable,
    required this.photoUrls,
  });

  final String title;
  final String description;
  final int priceRwf;
  final String categoryId;
  final String categoryName;
  final ListingCondition condition;
  final String? pickupHubId;
  final String? pickupHubName;
  final bool negotiable;
  final List<String> photoUrls;
}
