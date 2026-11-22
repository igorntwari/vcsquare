// The sample repositories serve the dummy data and remember toggles.
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/data/dummy/dummy_listings.dart';
import 'package:vsquare/data/dummy/dummy_posts.dart';
import 'package:vsquare/data/dummy/dummy_users.dart';
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
  });

  test('listings: categories, hubs and saved listings', () async {
    final repo = SampleListingsRepository();
    expect(await repo.fetchListings(), hasLength(dummyListings.length));
    expect(await repo.fetchCategories(), hasLength(8));
    expect(await repo.fetchPickupHubs(), hasLength(3));
    expect(await repo.fetchSavedListingIds(me), {'l04', 'l06', 'l14'});
    await repo.setSaved(userId: me, listingId: 'l01', saved: true);
    expect(await repo.fetchSavedListingIds(me), contains('l01'));
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
