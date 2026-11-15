// A student's profile details (bio, programme, follower counts...).
// Their posts and listings come from the posts and listings repositories.
import '../../models/profile_model.dart';

abstract interface class ProfileRepository {
  Future<ProfileModel> fetchProfile(String userId);
}
