// Sample-data profile: every id returns the sample student's profile.
import '../../dummy/dummy_profile.dart';
import '../../models/profile_model.dart';
import 'profile_repository.dart';

class SampleProfileRepository implements ProfileRepository {
  @override
  Future<ProfileModel> fetchProfile(String userId) async => dummyProfile;
}
