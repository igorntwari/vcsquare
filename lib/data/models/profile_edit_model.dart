// Profile fields a student can edit.
import 'firestore_helpers.dart';
import 'profile_model.dart';

class ProfileEdit {
  const ProfileEdit({
    required this.name,
    required this.handle,
    required this.roleTag,
    required this.campus,
    required this.program,
    required this.bio,
    this.cohort,
    this.bioHighlight,
    this.avatarPath,
  });

  factory ProfileEdit.fromProfile(ProfileModel profile) => ProfileEdit(
    name: profile.user.name,
    handle: profile.user.handle,
    cohort: profile.user.cohort,
    roleTag: profile.roleTag,
    campus: profile.campus,
    program: profile.program,
    bio: profile.bio,
    bioHighlight: profile.bioHighlight,
    avatarPath: profile.user.avatarPath,
  );

  final String name;
  final String handle;
  final String? cohort;
  final String roleTag;
  final String campus;
  final String program;
  final String bio;
  final String? bioHighlight;

  // Null means no photo.
  final String? avatarPath;

  ProfileEdit withAvatar(String? path) => ProfileEdit(
    name: name,
    handle: handle,
    cohort: cohort,
    roleTag: roleTag,
    campus: campus,
    program: program,
    bio: bio,
    bioHighlight: bioHighlight,
    avatarPath: path,
  );

  // Drops bioHighlight if the new bio no longer contains it.
  ProfileEdit normalized() {
    final trimmedBio = bio.trim();
    final trimmedCohort = cohort?.trim();
    return ProfileEdit(
      name: name.trim(),
      handle: handle.trim().toLowerCase(),
      cohort: (trimmedCohort == null || trimmedCohort.isEmpty)
          ? null
          : trimmedCohort,
      roleTag: roleTag.trim(),
      campus: campus.trim(),
      program: program.trim(),
      bio: trimmedBio,
      bioHighlight: bioHighlight != null && trimmedBio.contains(bioHighlight!)
          ? bioHighlight
          : null,
      avatarPath: avatarPath,
    );
  }

  FirestoreMap toFirestore() => {
    'name': name,
    'handle': handle,
    'cohort': cohort,
    'roleTag': roleTag,
    'campus': campus,
    'program': program,
    'bio': bio,
    'bioHighlight': bioHighlight,
    'avatarPath': avatarPath,
  };

  @override
  bool operator ==(Object other) =>
      other is ProfileEdit &&
      other.name == name &&
      other.handle == handle &&
      other.cohort == cohort &&
      other.roleTag == roleTag &&
      other.campus == campus &&
      other.program == program &&
      other.bio == bio &&
      other.bioHighlight == bioHighlight &&
      other.avatarPath == avatarPath;

  @override
  int get hashCode => Object.hash(
    name,
    handle,
    cohort,
    roleTag,
    campus,
    program,
    bio,
    bioHighlight,
    avatarPath,
  );
}
