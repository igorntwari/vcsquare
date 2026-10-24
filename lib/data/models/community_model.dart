// Model representing a campus community or club.
import 'user_model.dart';

class CommunityModel {
  const CommunityModel({
    required this.id,
    required this.name,
    required this.tag,
    required this.description,
    required this.memberCount,
    required this.activity,
    required this.members,
    this.imagePath,
    this.isJoined = false,
  });

  final String id;
  final String name;

  // Topic tag, e.g. "Tech".
  final String tag;
  final String description;
  final int memberCount;

  // Live status line, e.g. "Next meetup: Friday 18:00".
  final String activity;

  // A few members shown as an avatar pile.
  final List<UserModel> members;
  final String? imagePath;

  // Whether the current user was already a member when Explore loaded.
  final bool isJoined;
}
