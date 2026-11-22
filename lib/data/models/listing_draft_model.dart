import 'firestore_helpers.dart';
import 'listing_model.dart';

class ListingDraftModel {
  const ListingDraftModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priceText,
    required this.categoryId,
    required this.condition,
    required this.pickupHubId,
    required this.negotiable,
    required this.photoUrls,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String description;
  final String priceText;
  final String? categoryId;
  final ListingCondition? condition;
  final String? pickupHubId;
  final bool negotiable;
  final List<String> photoUrls;
  final DateTime updatedAt;

  factory ListingDraftModel.fromFirestore(String id, FirestoreMap data) =>
      ListingDraftModel(
        id: id,
        title: readString(data['title']),
        description: readString(data['description']),
        priceText: readString(data['priceText']),
        categoryId: data['categoryId'] as String?,
        condition: data['condition'] == null
            ? null
            : readEnum(
                ListingCondition.values,
                data['condition'],
                ListingCondition.used,
              ),
        pickupHubId: data['pickupHubId'] as String?,
        negotiable: data['negotiable'] as bool? ?? true,
        photoUrls: readStringList(data['photoUrls']),
        updatedAt: readDate(data['updatedAt']),
      );

  FirestoreMap toFirestore() => {
    'title': title,
    'description': description,
    'priceText': priceText,
    'categoryId': categoryId,
    'condition': condition?.name,
    'pickupHubId': pickupHubId,
    'negotiable': negotiable,
    'photoUrls': photoUrls,
    'updatedAt': writeDate(updatedAt),
  };
}
