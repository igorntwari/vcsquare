// The sample repositories serve the dummy data and remember toggles.
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/data/dummy/dummy_listings.dart';
import 'package:vsquare/data/dummy/dummy_posts.dart';
import 'package:vsquare/data/dummy/dummy_users.dart';
import 'package:vsquare/data/models/listing_draft_model.dart';
import 'package:vsquare/data/models/listing_model.dart';
import 'package:vsquare/data/models/post_model.dart';
import 'package:vsquare/data/repositories/auth/sample_auth_repository.dart';
import 'package:vsquare/data/repositories/chats/sample_chats_repository.dart';
import 'package:vsquare/data/repositories/explore/sample_explore_repository.dart';
import 'package:vsquare/data/repositories/listings/sample_listings_repository.dart';
import 'package:vsquare/data/repositories/posts/sample_posts_repository.dart';
import 'package:vsquare/data/repositories/profile/sample_profile_repository.dart';

void main() {
  final me = dummyCurrentUser.id;

  test('auth starts signed in as the sample student', () async {
    final auth = SampleAuthRepository();
    expect(await auth.watchCurrentUser().first, dummyCurrentUser);
  });

  test('posts: feed, by author, and likes', () async {
    final repo = SamplePostsRepository();
    expect(await repo.fetchFeed(), hasLength(dummyPosts.length));
    final mine = await repo.fetchPostsByAuthor(me);
    expect(mine, isNotEmpty);
    expect(mine.every((post) => post.author.id == me), isTrue);

    expect(await repo.fetchLikedPostIds(me), {'p05', 'p16', 'p21'});
    await repo.setLiked(userId: me, postId: 'p01', liked: true);
    await repo.setLiked(userId: me, postId: 'p05', liked: false);
    expect(await repo.fetchLikedPostIds(me), {'p01', 'p16', 'p21'});

    final countUpdates = repo.watchPostCounts('p01').take(2).toList();
    await Future<void>.delayed(Duration.zero);
    await repo.setLiked(userId: 'another-user', postId: 'p01', liked: true);
    expect(
      (await countUpdates).last.likeCount,
      dummyPosts.firstWhere((p) => p.id == 'p01').likeCount + 1,
    );

    await repo.setPollVote(userId: me, postId: 'p01', option: 'Option 1');
    await repo.setPollVote(
      userId: 'another-user',
      postId: 'p01',
      option: 'Option 1',
    );
    expect(await repo.watchPollCounts('p01').first, {'Option 1': 2});
    await repo.setPollVote(userId: me, postId: 'p01', option: 'Option 2');
    expect(await repo.watchPollCounts('p01').first, {
      'Option 1': 1,
      'Option 2': 1,
    });

    final createdId = await repo.createPost(mine.first);
    await repo.updatePost(
      PostModel(
        id: createdId,
        author: mine.first.author,
        createdAt: mine.first.createdAt,
        body: 'Updated sample post',
      ),
    );
    expect(
      (await repo.fetchPostsByAuthor(me))
          .firstWhere((post) => post.id == createdId)
          .body,
      'Updated sample post',
    );
    await repo.deletePost(createdId);
    expect(
      (await repo.fetchPostsByAuthor(me)).any((post) => post.id == createdId),
      isFalse,
    );
  });

  test('listings: categories, hubs and saved listings', () async {
    final repo = SampleListingsRepository();
    expect(await repo.fetchListings(), hasLength(dummyListings.length));
    expect(await repo.fetchCategories(), hasLength(8));
    expect(await repo.fetchPickupHubs(), hasLength(3));
    expect(await repo.fetchSavedListingIds(me), {'l04', 'l06', 'l14'});
    await repo.setSaved(userId: me, listingId: 'l01', saved: true);
    expect(await repo.fetchSavedListingIds(me), contains('l01'));

    final createdId = await repo.createListing(dummyListings.first);
    final created = (await repo.fetchListingsBySeller(
      dummyListings.first.seller.id,
    )).firstWhere((listing) => listing.id == createdId);
    await repo.updateListing(created.copyWith(title: 'Updated sample listing'));
    expect(
      (await repo.fetchListingsBySeller(dummyListings.first.seller.id))
          .firstWhere((listing) => listing.id == createdId)
          .title,
      'Updated sample listing',
    );
    await repo.deleteListing(createdId);
    expect(
      (await repo.fetchListings()).any((listing) => listing.id == createdId),
      isFalse,
    );
  });

  test('listings: seller updates and removes listings and drafts', () async {
    final repo = SampleListingsRepository();
    final listing = dummyListings.first;
    await repo.updateListing(
      ListingModel(
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
      ),
    );
    expect(
      (await repo.fetchListings())
          .firstWhere((item) => item.id == listing.id)
          .status,
      'sold',
    );
    await repo.deleteListing(listing.id);
    expect(
      (await repo.fetchListings()).any((item) => item.id == listing.id),
      isFalse,
    );

    final draft = ListingDraftModel(
      id: '',
      title: 'Desk',
      description: '',
      priceText: '',
      categoryId: null,
      condition: null,
      pickupHubId: null,
      negotiable: true,
      photoUrls: const [],
      updatedAt: DateTime(2026),
    );
    final id = await repo.saveDraft(userId: me, draft: draft);
    expect((await repo.fetchDrafts(me)).single.title, 'Desk');
    await repo.deleteDraft(userId: me, draftId: id);
    expect(await repo.fetchDrafts(me), isEmpty);
  });

  test('explore: follows and joins', () async {
    final repo = SampleExploreRepository();
    expect(await repo.fetchFollowingIds(me), {'h_registry'});
    expect(await repo.fetchJoinedIds(me), {'c_gdg'});
    await repo.setFollowing(userId: me, targetId: 'h_careers', following: true);
    await repo.setJoined(userId: me, groupId: 'c_gdg', joined: false);
    expect(await repo.fetchFollowingIds(me), {'h_registry', 'h_careers'});
    expect(await repo.fetchJoinedIds(me), isEmpty);
  });

  test('profile returns the sample profile', () async {
    final profile = await SampleProfileRepository().fetchProfile(me);
    expect(profile.user.id, me);
  });

  test('chats: sending a message updates the stream', () async {
    final repo = SampleChatsRepository();
    final conversations = await repo.fetchConversations(me);
    final id = conversations.first.id;

    final updates = repo.watchMessages(id).take(2).toList();
    await Future<void>.delayed(Duration.zero);
    await repo.sendMessage(conversationId: id, senderId: me, text: 'Hello');
    final emitted = await updates;
    expect(emitted.last.last.text, 'Hello');
    expect(emitted.last.last.isFrom(me), isTrue);

    await repo.markRead(conversationId: id, userId: me);
    final after = await repo.fetchConversations(me);
    expect(after.first.unreadCount, 0);
    expect(after.first.lastMessage.text, 'Hello');
  });
}
