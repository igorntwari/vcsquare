// Model representing the signed-in student's profile details.
import 'user_model.dart';

class ProfileModel {
  const ProfileModel({
    required this.user,
    required this.emailDomain,
    required this.roleTag,
    required this.campus,
    required this.program,
    required this.bio,
    required this.followerCount,
    required this.followingCount,
    required this.recognitionTitle,
    required this.recognitionSubtitle,
    this.bioHighlight,
  });

  final UserModel user;

  // Verified school email domain, e.g. "@alustudent.com".
  final String emailDomain;

  // e.g. "Student Leader • Year 3"
  final String roleTag;
  final String campus;

  // e.g. "BSc Software Engineering • Class of 2027"
  final String program;
  final String bio;

  // Part of [bio] shown in bold, e.g. a club name.
  final String? bioHighlight;
  final int followerCount;
  final int followingCount;
  final String recognitionTitle;
  final String recognitionSubtitle;
}
