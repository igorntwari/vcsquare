// Data for the Home feed.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/post_model.dart';
import '../../../data/repositories/repository_providers.dart';

typedef HomeFeed = ({
  List<PostModel> posts,
  // Posts the signed-in user has liked.
  Set<String> likedPostIds,
  // Clubs the signed-in user is a member of.
  Set<String> joinedIds,
});

final homeFeedProvider = FutureProvider<HomeFeed>((ref) async {
  final userId = await ref.watch(currentUserIdProvider.future);
  final posts = ref.watch(postsRepositoryProvider);
  final explore = ref.watch(exploreRepositoryProvider);

  final (feed, liked, joined) = await (
    posts.fetchFeed(),
    userId == null
        ? Future.value(<String>{})
        : posts.fetchLikedPostIds(userId),
    userId == null ? Future.value(<String>{}) : explore.fetchJoinedIds(userId),
  ).wait;
  return (posts: feed, likedPostIds: liked, joinedIds: joined);
});
