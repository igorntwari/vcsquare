// Firestore listings: listings/{id}, categories/{id}, pickupHubs/{id}, and
// users/{uid}/savedListings/{listingId}.
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/category_model.dart';
import '../../models/firestore_helpers.dart';
import '../../models/listing_draft_model.dart';
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
  Future<String> createListing(ListingModel listing) async {
    final reference = _listings.doc();
    await reference.set(listing.toFirestore());
    return reference.id;
  }

  @override
  Future<void> updateListing(ListingModel listing) =>
      _listings.doc(listing.id).update({
        'title': listing.title,
        'details': listing.details,
        'priceRwf': listing.priceRwf,
        'condition': listing.condition.name,
        'categoryId': listing.categoryId,
        'imagePath': listing.imagePath,
        'photoUrls': listing.photoUrls,
        'pickupHubId': listing.pickupHubId,
        'negotiable': listing.negotiable,
        'status': listing.status,
        'tag': listing.tag,
        'tagStyle': listing.tagStyle.name,
      });

  @override
  Future<void> deleteListing(String listingId) =>
      _listings.doc(listingId).delete();

  CollectionReference<Map<String, dynamic>> _draftsOf(String userId) => _db
      .collection(FirestoreCollections.users)
      .doc(userId)
      .collection(FirestoreCollections.listingDrafts);

  @override
  Future<List<ListingDraftModel>> fetchDrafts(String userId) async {
    final snapshot = await _draftsOf(userId)
        .orderBy('updatedAt', descending: true)
        .get();
    return [
      for (final doc in snapshot.docs)
        ListingDraftModel.fromFirestore(doc.id, doc.data()),
    ];
  }

  @override
  Future<String> saveDraft({
    required String userId,
    required ListingDraftModel draft,
  }) async {
    final reference = draft.id.isEmpty
        ? _draftsOf(userId).doc()
        : _draftsOf(userId).doc(draft.id);
    await reference.set({
      ...draft.toFirestore(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return reference.id;
  }

  @override
  Future<void> deleteDraft({required String userId, required String draftId}) =>
      _draftsOf(userId).doc(draftId).delete();

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