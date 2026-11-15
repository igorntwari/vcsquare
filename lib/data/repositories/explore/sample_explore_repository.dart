// Sample-data explore. Follows and joins are kept in memory.
import '../../dummy/dummy_communities.dart';
import '../../dummy/dummy_official_handles.dart';
import '../../dummy/dummy_peer_suggestions.dart';
import '../../dummy/dummy_trending_topics.dart';
import '../../dummy/dummy_viewer_state.dart';
import '../../models/community_model.dart';
import '../../models/official_handle_model.dart';
import '../../models/peer_suggestion_model.dart';
import '../../models/trending_topic_model.dart';
import 'explore_repository.dart';

class SampleExploreRepository implements ExploreRepository {
  final Set<String> _followingIds = {...dummyFollowingIds};
  final Set<String> _joinedIds = {...dummyJoinedIds};

  @override
  Future<List<TrendingTopicModel>> fetchTrendingTopics() async =>
      dummyTrendingTopics;

  @override
  Future<List<OfficialHandleModel>> fetchOfficialHandles() async =>
      dummyOfficialHandles;

  @override
  Future<List<CommunityModel>> fetchCommunities() async => dummyCommunities;

  @override
  Future<List<PeerSuggestionModel>> fetchPeerSuggestions(String userId) async =>
      dummyPeerSuggestions;

  @override
  Future<Set<String>> fetchFollowingIds(String userId) async =>
      {..._followingIds};

  @override
  Future<void> setFollowing({
    required String userId,
    required String targetId,
    required bool following,
  }) async {
    following ? _followingIds.add(targetId) : _followingIds.remove(targetId);
  }

  @override
  Future<Set<String>> fetchJoinedIds(String userId) async => {..._joinedIds};

  @override
  Future<void> setJoined({
    required String userId,
    required String groupId,
    required bool joined,
  }) async {
    joined ? _joinedIds.add(groupId) : _joinedIds.remove(groupId);
  }
}
