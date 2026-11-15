// Model representing a student, campus office or club that can post.
import 'firestore_helpers.dart';

enum AuthorType { student, official, club }

class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.handle,
    this.type = AuthorType.student,
    this.avatarPath,
    this.cohort,
    this.isVerified = false,
    this.isOnline = false,
  });

  final String id;
  final String name;
  final String handle;
  final AuthorType type;
  final String? avatarPath;

  // Students only, e.g. "ALU '26".
  final String? cohort;
  final bool isVerified;
  final bool isOnline;

  bool get isStudent => type == AuthorType.student;
  bool get isOfficial => type == AuthorType.official;
  bool get isClub => type == AuthorType.club;

  // users/{id}
  factory UserModel.fromFirestore(String id, FirestoreMap data) => UserModel(
    id: id,
    name: readString(data['name']),
    handle: readString(data['handle']),
    type: readEnum(AuthorType.values, data['type'], AuthorType.student),
    avatarPath: data['avatarPath'] as String?,
    cohort: data['cohort'] as String?,
    isVerified: data['isVerified'] as bool? ?? false,
    isOnline: data['isOnline'] as bool? ?? false,
  );

  FirestoreMap toFirestore() => {
    'name': name,
    'handle': handle,
    'type': type.name,
    'avatarPath': avatarPath,
    'cohort': cohort,
    'isVerified': isVerified,
    'isOnline': isOnline,
  };
}
