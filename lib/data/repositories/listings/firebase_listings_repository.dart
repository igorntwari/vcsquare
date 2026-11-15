// Firestore listings: listings/{id}, categories/{id}, pickupHubs/{id}, and
// users/{uid}/savedListings/{listingId}.
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/category_model.dart';
import '../../models/firestore_helpers.dart';
import '../../models/listing_model.dart';
import '../../models/pickup_hub_model.dart';
import '../firebase/firestore_collections.dart';
import '../firebase/user_lookup.dart';
import 'listings_repository.dart';

class FirebaseListingsRepository implements ListingsRepository {
  FirebaseListingsRepository(this._db) : _users = UserLookup(_db);

  final FirebaseFirestore _db;
  final UserLookup _users;

  static const int _listingsLimit = 100;

  CollectionReference<Map<String, dynamic>> get _listings =>
      _db.collection(FirestoreCollections.listings);

  @override
  Future<List<ListingModel>> fetchListings() async {
    final snapshot = await _listings
        .orderBy('createdAt', descending: true)
        .limit(_listingsLimit)
        .get();
    return toListings(snapshot.docs);
  }

  @override
  Future<List<ListingModel>> fetchListingsBySeller(String sellerId) async {
    final snapshot = await _listings
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .get();
    return toListings(snapshot.docs);
  }

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    final snapshot = await _db
        .collection(FirestoreCollections.categories)
        .orderBy('order')
        .get();
    return [
      for (final doc in snapshot.docs)
        CategoryModel.fromFirestore(doc.id, doc.data()),
    ];
  }

  @override
  Future<List<PickupHubModel>> fetchPickupHubs() async {
    final snapshot = await _db
        .collection(FirestoreCollections.pickupHubs)
        .orderBy('order')
        .get();
    return [
      for (final doc in snapshot.docs)
        PickupHubModel.fromFirestore(doc.id, doc.data()),
    ];
  }

  @override
  Future<Set<String>> fetchSavedListingIds(String userId) =>
      readIdSet(_db, userId, FirestoreCollections.savedListings);

  @override
  Future<void> setSaved({
    required String userId,
    required String listingId,
    required bool saved,
  }) => writeIdFlag(
    _db,
    userId: userId,
    subcollection: FirestoreCollections.savedListings,
    id: listingId,
    value: saved,
  );

  // Also used by the chats repository for the listing a chat is about.
  Future<List<ListingModel>> toListings(
    List<DocumentSnapshot<Map<String, dynamic>>> docs,
  ) async {
    final existing = docs.where((doc) => doc.exists).toList();
    final sellers = await _users.byIds([
      for (final doc in existing) readString(doc.data()!['sellerId']),
    ]);
    return [
      for (final doc in existing)
        ListingModel.fromFirestore(
          doc.id,
          doc.data()!,
          seller:
              sellers[readString(doc.data()!['sellerId'])] ??
              UserLookup.placeholder(readString(doc.data()!['sellerId'])),
        ),
    ];
  }
}
