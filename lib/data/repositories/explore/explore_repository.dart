// Explore content, plus what the user follows and has joined.
import '../../models/community_model.dart';
import '../../models/official_handle_model.dart';
import '../../models/peer_suggestion_model.dart';
import '../../models/trending_topic_model.dart';

abstract interface class ExploreRepository {
  // Busiest first.
  Future<List<TrendingTopicModel>> fetchTrendingTopics();

  // In display order.
  Future<List<OfficialHandleModel>> fetchOfficialHandles();

  // In display order.
  Future<List<CommunityModel>> fetchCommunities();

  Future<List<PeerSuggestionModel>> fetchPeerSuggestions(String userId);

  // Ids of official accounts and people the user follows.
  Future<Set<String>> fetchFollowingIds(String userId);

  Future<void> setFollowing({
    required String userId,
    required String targetId,
    required bool following,
  });

  // Ids of communities and clubs the user is a member of.
  Future<Set<String>> fetchJoinedIds(String userId);

  Future<void> setJoined({
    required String userId,
    required String groupId,
    required bool joined,
  });
}
