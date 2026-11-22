// Data for the Home feed.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/post_model.dart';
import '../../../data/repositories/repository_providers.dart';

typedef HomeFeed = ({
  List<PostModel> posts,
  // Posts the signed-in user has liked.
  Set<String> likedPostIds,
  Set<String> rsvpedPostIds,
  Set<String> savedPostIds,
  Map<String, String> pollVoteOptions,
  // Clubs the signed-in user is a member of.
  Set<String> joinedIds,
  // Official accounts and people the signed-in user follows.
  Set<String> followedIds,
});

final homeFeedProvider = FutureProvider<HomeFeed>((ref) async {
  final userId = await ref.watch(currentUserIdProvider.future);
  final posts = ref.watch(postsRepositoryProvider);
  final explore = ref.watch(exploreRepositoryProvider);

  final (feed, liked, rsvped, saved, pollVotes, joined, followed) = await (
    posts.fetchFeed(),
    userId == null ? Future.value(<String>{}) : posts.fetchLikedPostIds(userId),
    userId == null
        ? Future.value(<String>{})
        : posts.fetchRsvpedPostIds(userId),
    userId == null ? Future.value(<String>{}) : posts.fetchSavedPostIds(userId),
    userId == null
        ? Future.value(<String, String>{})
        : posts.fetchPollVotes(userId),
    userId == null ? Future.value(<String>{}) : explore.fetchJoinedIds(userId),
    userId == null
        ? Future.value(<String>{})
        : explore.fetchFollowingIds(userId),
  ).wait;
  return (
    posts: feed,
    likedPostIds: liked,
    rsvpedPostIds: rsvped,
    savedPostIds: saved,
    pollVoteOptions: pollVotes,
    joinedIds: joined,
    followedIds: followed,
  );
});
