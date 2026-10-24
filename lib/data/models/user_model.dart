// Model representing a student, campus office or club that can post.
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
    this.isJoined = false,
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

  // Clubs only: whether the current user is already a member.
  final bool isJoined;

  bool get isStudent => type == AuthorType.student;
  bool get isOfficial => type == AuthorType.official;
  bool get isClub => type == AuthorType.club;
}
