// Model representing a hashtag trending on campus.
class TrendingTopicModel {
  const TrendingTopicModel({required this.tag, required this.activity});

  // Hashtag including the "#", e.g. "#ALUHackathon2026".
  final String tag;

  // How busy it is, e.g. "1.4k talks".
  final String activity;
}
