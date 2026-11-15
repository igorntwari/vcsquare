// Firebase auth: Google sign-in, with the profile kept in users/{uid}.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/user_model.dart';
import '../firebase/firestore_collections.dart';
import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._auth, this._db, {GoogleSignIn? googleSignIn})
    : _google = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final GoogleSignIn _google;
  Future<void>? _googleReady;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection(FirestoreCollections.users).doc(uid);

  @override
  Stream<UserModel?> watchCurrentUser() =>
      _auth.authStateChanges().asyncExpand((user) {
        if (user == null) return Stream<UserModel?>.value(null);
        return _userDoc(user.uid).snapshots().map(
          (doc) => doc.exists
              ? UserModel.fromFirestore(doc.id, doc.data()!)
              : _fromAuthUser(user),
        );
      });

  @override
  Future<UserModel> signInWithGoogle() async {
    // On Android the web client id comes from google-services.json.
    await (_googleReady ??= _google.initialize());
    final account = await _google.authenticate();
    final credential = GoogleAuthProvider.credential(
      idToken: account.authentication.idToken,
    );
    final result = await _auth.signInWithCredential(credential);
    final user = result.user!;

    // First sign-in: create the public profile. Later sign-ins leave it.
    final doc = _userDoc(user.uid);
    final snapshot = await doc.get();
    if (snapshot.exists) {
      return UserModel.fromFirestore(snapshot.id, snapshot.data()!);
    }
    final profile = _fromAuthUser(user);
    await doc.set({
      ...profile.toFirestore(),
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return profile;
  }

  @override
  Future<void> signOut() async {
    await _google.signOut();
    await _auth.signOut();
  }

  static UserModel _fromAuthUser(User user) {
    final email = user.email ?? '';
    final localPart = email.contains('@') ? email.split('@').first : user.uid;
    return UserModel(
      id: user.uid,
      name: user.displayName ?? localPart,
      handle: '@$localPart',
      avatarPath: user.photoURL,
    );
  }
}
