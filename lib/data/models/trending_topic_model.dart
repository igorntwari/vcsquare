// Model representing a hashtag trending on campus.
import 'firestore_helpers.dart';

class TrendingTopicModel {
  const TrendingTopicModel({
    required this.tag,
    required this.activity,
    this.rank = 0,
  });

  // Hashtag including the "#", e.g. "#ALUHackathon2026".
  final String tag;

  // How busy it is, e.g. "1.4k talks".
  final String activity;

  // Lowest first.
  final int rank;

  // trendingTopics/{auto id}
  factory TrendingTopicModel.fromFirestore(FirestoreMap data) =>
      TrendingTopicModel(
        tag: readString(data['tag']),
        activity: readString(data['activity']),
        rank: readInt(data['rank']),
      );

  FirestoreMap toFirestore() => {
    'tag': tag,
    'activity': activity,
    'rank': rank,
  };
}
