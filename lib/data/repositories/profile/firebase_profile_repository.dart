// Firestore profile: the profile fields live in users/{uid}.
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/profile_model.dart';
import '../../models/user_model.dart';
import '../firebase/firestore_collections.dart';
import 'profile_repository.dart';

class FirebaseProfileRepository implements ProfileRepository {
  FirebaseProfileRepository(this._db);

  final FirebaseFirestore _db;

  @override
  Future<ProfileModel> fetchProfile(String userId) async {
    final doc = await _db
        .collection(FirestoreCollections.users)
        .doc(userId)
        .get();
    final data = doc.data() ?? const <String, dynamic>{};
    return ProfileModel.fromFirestore(
      data,
      user: UserModel.fromFirestore(userId, data),
    );
  }
}
