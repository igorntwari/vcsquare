// Model representing a campus community or club.
import 'firestore_helpers.dart';
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
    this.order = 0,
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
  final int order;

  // communities/{id}. [members] are looked up from memberPreviewIds.
  factory CommunityModel.fromFirestore(
    String id,
    FirestoreMap data, {
    List<UserModel> members = const [],
  }) => CommunityModel(
    id: id,
    name: readString(data['name']),
    tag: readString(data['tag']),
    description: readString(data['description']),
    memberCount: readInt(data['memberCount']),
    activity: readString(data['activity']),
    members: members,
    imagePath: data['imagePath'] as String?,
    order: readInt(data['order']),
  );

  static List<String> memberPreviewIdsOf(FirestoreMap data) =>
      readStringList(data['memberPreviewIds']);

  FirestoreMap toFirestore() => {
    'name': name,
    'tag': tag,
    'description': description,
    'memberCount': memberCount,
    'activity': activity,
    'memberPreviewIds': [for (final member in members) member.id],
    'imagePath': imagePath,
    'order': order,
  };
}
