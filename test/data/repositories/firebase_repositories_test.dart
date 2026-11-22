// The Firebase repositories against an in-memory Firestore
// (fake_cloud_firestore). Security rules are not checked here; use the
// Emulator Suite for that.
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/data/dummy/dummy_categories.dart';
import 'package:vsquare/data/dummy/dummy_communities.dart';
import 'package:vsquare/data/dummy/dummy_conversations.dart';
import 'package:vsquare/data/dummy/dummy_listings.dart';
import 'package:vsquare/data/dummy/dummy_posts.dart';
import 'package:vsquare/data/dummy/dummy_profile.dart';
import 'package:vsquare/data/dummy/dummy_users.dart';
import 'package:vsquare/data/models/listing_draft_model.dart';
import 'package:vsquare/data/models/listing_model.dart';
import 'package:vsquare/data/repositories/chats/firebase_chats_repository.dart';
import 'package:vsquare/data/repositories/explore/firebase_explore_repository.dart';
import 'package:vsquare/data/repositories/listings/firebase_listings_repository.dart';
import 'package:vsquare/data/repositories/posts/firebase_posts_repository.dart';
import 'package:vsquare/data/repositories/profile/firebase_profile_repository.dart';

void main() {
  late FakeFirebaseFirestore db;
  final me = dummyCurrentUser.id;

  setUp(() async {
    db = FakeFirebaseFirestore();
    for (final user in dummyUsers) {
      await db.collection('users').doc(user.id).set(user.toFirestore());
    }
    await db.collection('users').doc(me).set(dummyProfile.toFirestore());
    for (final post in dummyPosts) {
      await db.collection('posts').doc(post.id).set(post.toFirestore());
    }
    for (final listing in dummyListings) {
      await db
          .collection('listings')
          .doc(listing.id)
          .set(listing.toFirestore());
    }
  });

  test('posts resolve authors and keep like counts in step', () async {
    final repo = FirebasePostsRepository(db);
    final feed = await repo.fetchFeed();
    expect(feed, hasLength(dummyPosts.length));
    final p01 = feed.firstWhere((post) => post.id == 'p01');
    expect(p01.author.name, aluRegistry.name);

    await repo.setLiked(userId: me, postId: 'p01', liked: true);
    // Liking twice must not count twice.
    await repo.setLiked(userId: me, postId: 'p01', liked: true);
    expect(await repo.fetchLikedPostIds(me), {'p01'});
    final liked = await db.collection('posts').doc('p01').get();
    expect(liked['likeCount'], p01.likeCount + 1);

    await repo.setLiked(userId: me, postId: 'p01', liked: false);
    final unliked = await db.collection('posts').doc('p01').get();
    expect(unliked['likeCount'], p01.likeCount);
    expect(await repo.fetchLikedPostIds(me), isEmpty);
  });

  test('listings, ordered categories and saved listings', () async {
    for (final c in dummyCategories.reversed) {
      await db.collection('categories').doc(c.id).set(c.toFirestore());
    }
    final repo = FirebaseListingsRepository(db);
    final categories = await repo.fetchCategories();
    expect(categories.map((c) => c.id), dummyCategories.map((c) => c.id));

    final listings = await repo.fetchListings();
    expect(listings, hasLength(dummyListings.length));
    expect(listings.first.seller.name, isNotEmpty);

    await repo.setSaved(userId: me, listingId: 'l03', saved: true);
    expect(await repo.fetchSavedListingIds(me), {'l03'});
  });

  test('listings: drafts and seller status updates persist', () async {
    final repo = FirebaseListingsRepository(db);
    final listing = dummyListings.first;
    final updated = ListingModel(
      id: listing.id,
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
      status: 'sold',
      tag: listing.tag,
      tagStyle: listing.tagStyle,
    );
    await repo.updateListing(updated);
    expect(
      (await db.collection('listings').doc(listing.id).get())['status'],
      'sold',
    );

    final id = await repo.saveDraft(
      userId: me,
      draft: ListingDraftModel(
        id: '',
        title: 'Desk',
        description: 'Wooden desk',
        priceText: '25000',
        categoryId: 'furniture',
        condition: listing.condition,
        pickupHubId: 'library',
        negotiable: true,
        photoUrls: const [],
        updatedAt: DateTime(2026),
      ),
    );
    expect((await repo.fetchDrafts(me)).single.title, 'Desk');
    await repo.deleteDraft(userId: me, draftId: id);
    expect(await repo.fetchDrafts(me), isEmpty);
    await repo.deleteListing(listing.id);
    expect(
      await db
          .collection('listings')
          .doc(listing.id)
          .get()
          .then((d) => d.exists),
      isFalse,
    );
  });

  test('communities resolve member previews; follows and joins', () async {
    for (final c in dummyCommunities) {
      await db.collection('communities').doc(c.id).set(c.toFirestore());
    }
    final repo = FirebaseExploreRepository(db);
    final communities = await repo.fetchCommunities();
    expect(
      communities.first.members.map((m) => m.id),
      dummyCommunities.first.members.map((m) => m.id),
    );

    await repo.setFollowing(
      userId: me,
      targetId: 'h_registry',
      following: true,
    );
    await repo.setJoined(userId: me, groupId: 'cm_debate', joined: true);
    expect(await repo.fetchFollowingIds(me), {'h_registry'});
    expect(await repo.fetchJoinedIds(me), {'cm_debate'});
  });

  test('profile reads the users document', () async {
    final profile = await FirebaseProfileRepository(db).fetchProfile(me);
    expect(profile.user.name, dummyCurrentUser.name);
    expect(profile.bio, dummyProfile.bio);
  });

  test('chats: send bumps the other side unread count', () async {
    final conversation = dummyConversations.first;
    await db
        .collection('conversations')
        .doc(conversation.id)
        .set(conversation.toFirestore(currentUserId: me));
    final repo = FirebaseChatsRepository(db);

    final list = await repo.fetchConversations(me);
    expect(list.single.participant.id, conversation.participant.id);
    expect(list.single.listing?.id, conversation.listing?.id);

    await repo.sendMessage(
      conversationId: conversation.id,
      senderId: me,
      text: 'Still available?',
    );
    final messages = await repo.watchMessages(conversation.id).first;
    expect(messages.single.text, 'Still available?');

    final doc = await db.collection('conversations').doc(conversation.id).get();
    expect(doc['unreadCounts'][conversation.participant.id], 1);

    await repo.markRead(conversationId: conversation.id, userId: me);
    expect((await repo.fetchConversations(me)).single.unreadCount, 0);
  });
}
