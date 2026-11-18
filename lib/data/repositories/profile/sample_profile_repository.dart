// Sample-data profile. Edits stay in memory.
import '../../dummy/dummy_profile.dart';
import '../../models/profile_edit_model.dart';
import '../../models/profile_model.dart';
import '../../models/user_model.dart';
import 'profile_repository.dart';

class SampleProfileRepository implements ProfileRepository {
  ProfileModel _profile = dummyProfile;

  @override
  Future<ProfileModel> fetchProfile(String userId) async => _profile;

  @override
  Future<void> updateProfile(String userId, ProfileEdit edit) async {
    final user = _profile.user;
    _profile = ProfileModel(
      user: UserModel(
        id: user.id,
        name: edit.name,
        handle: edit.handle,
        type: user.type,
        avatarPath: user.avatarPath,
        cohort: edit.cohort,
        isVerified: user.isVerified,
        isOnline: user.isOnline,
      ),
      emailDomain: _profile.emailDomain,
      roleTag: edit.roleTag,
      campus: edit.campus,
      program: edit.program,
      bio: edit.bio,
      bioHighlight: edit.bioHighlight,
      followerCount: _profile.followerCount,
      followingCount: _profile.followingCount,
      recognitionTitle: _profile.recognitionTitle,
      recognitionSubtitle: _profile.recognitionSubtitle,
    );
  }
}
