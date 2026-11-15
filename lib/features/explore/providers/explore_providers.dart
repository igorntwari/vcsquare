// Data for the Explore screen.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/community_model.dart';
import '../../../data/models/official_handle_model.dart';
import '../../../data/models/peer_suggestion_model.dart';
import '../../../data/models/trending_topic_model.dart';
import '../../../data/repositories/repository_providers.dart';

typedef ExploreData = ({
  List<TrendingTopicModel> trendingTopics,
  List<OfficialHandleModel> officialHandles,
  List<CommunityModel> communities,
  List<PeerSuggestionModel> peerSuggestions,
  // Official accounts the signed-in user follows.
  Set<String> followingIds,
  // Communities the signed-in user has joined.
  Set<String> joinedIds,
});

final exploreProvider = FutureProvider<ExploreData>((ref) async {
  final userId = await ref.watch(currentUserIdProvider.future);
  final repo = ref.watch(exploreRepositoryProvider);

  final (topics, handles, communities, suggestions, following, joined) =
      await (
        repo.fetchTrendingTopics(),
        repo.fetchOfficialHandles(),
        repo.fetchCommunities(),
        userId == null
            ? Future.value(<PeerSuggestionModel>[])
            : repo.fetchPeerSuggestions(userId),
        userId == null
            ? Future.value(<String>{})
            : repo.fetchFollowingIds(userId),
        userId == null ? Future.value(<String>{}) : repo.fetchJoinedIds(userId),
      ).wait;
  return (
    trendingTopics: topics,
    officialHandles: handles,
    communities: communities,
    peerSuggestions: suggestions,
    followingIds: following,
    joinedIds: joined,
  );
});
