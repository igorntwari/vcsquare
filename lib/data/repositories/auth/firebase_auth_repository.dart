// Firebase auth for ALU accounts, with the profile in users/{uid}.
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/validators.dart';
import '../../models/auth_account_model.dart';
import '../../models/user_model.dart';
import '../firebase/account_data_eraser.dart';
import '../firebase/firestore_collections.dart';
import 'auth_failure.dart';
import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._auth, this._db, {GoogleSignIn? googleSignIn})
    : _googleOverride = googleSignIn;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final GoogleSignIn? _googleOverride;
  Future<void>? _googleReady;

  // Lazy, so email-only paths and tests never touch the Google plugin.
  GoogleSignIn get _google => _googleOverride ?? GoogleSignIn.instance;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection(FirestoreCollections.users).doc(uid);

  @override
  Stream<AuthAccount?> watchAccount() =>
      // userChanges also fires after reload(), unlike authStateChanges.
      _auth.userChanges().map((user) => user == null ? null : _toAccount(user));

  @override
  Stream<UserModel?> watchCurrentUser() =>
      _auth.authStateChanges().asyncExpand((user) {
        if (user == null) return Stream<UserModel?>.value(null);
        return _userDoc(user.uid).snapshots().map(
          (doc) => doc.exists
              ? UserModel.fromFirestore(doc.id, doc.data()!)
              : _cardFor(user),
        );
      });

  @override
  Future<void> signInWithGoogle() => _guard(() async {
    final idToken = await _pickGoogleAccount();
    final result = await _auth.signInWithCredential(
      GoogleAuthProvider.credential(idToken: idToken),
    );
    await _ensureUserDoc(result.user!);
  });

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) => _guard(() async {
    _requireAluEmail(email);
    final result = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await _ensureUserDoc(result.user!);
  });

  @override
  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) => _guard(() async {
    _requireAluEmail(email);
    final result = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = result.user!;
    await user.updateDisplayName(name.trim());
    await _ensureUserDoc(user, name: name.trim());
    await user.sendEmailVerification();
  });

  @override
  Future<void> sendEmailVerification() => _guard(() async {
    await _auth.currentUser?.sendEmailVerification();
  });

  @override
  Future<bool> reloadAccount() => _guard(() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    await user.reload();
    final fresh = _auth.currentUser!;
    // Rules read email_verified from the token, so refresh it.
    if (fresh.emailVerified) await fresh.getIdToken(true);
    return fresh.emailVerified;
  });

  @override
  Future<void> sendPasswordResetEmail(String email) => _guard(() async {
    _requireAluEmail(email);
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (error) {
      if (error.code != 'user-not-found') rethrow;
    }
  });

  @override
  Future<void> signOut() => _guard(() async {
    final user = _auth.currentUser;
    if (user != null && _methodOf(user) == AuthMethod.google) {
      await _google.signOut();
    }
    await _auth.signOut();
  });

  @override
  Future<void> deleteAccount({String? password}) => _guard(() async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Firebase only deletes recently signed-in accounts.
    final AuthCredential credential = switch (_methodOf(user)) {
      AuthMethod.password => EmailAuthProvider.credential(
        email: user.email!,
        password: password ?? '',
      ),
      AuthMethod.google => GoogleAuthProvider.credential(
        idToken: await _pickGoogleAccount(),
      ),
    };
    await user.reauthenticateWithCredential(credential);

    await AccountDataEraser(_db).erase(user.uid);
    final wasGoogle = _methodOf(user) == AuthMethod.google;
    await user.delete();
    if (wasGoogle) await _google.signOut();
  });

  Future<String?> _pickGoogleAccount() async {
    // On Android the web client id comes from google-services.json.
    await (_googleReady ??= _google.initialize());
    final account = await _google.authenticate();
    if (!Validators.isAllowedEmail(account.email)) {
      await _google.signOut();
      throw const AuthFailure(AuthFailureCode.domainNotAllowed);
    }
    return account.authentication.idToken;
  }

  Future<void> _ensureUserDoc(User user, {String? name}) async {
    final doc = _userDoc(user.uid);
    if ((await doc.get()).exists) return;
    await doc.set(newUserDoc(user, name: name));
  }

  // firestore.rules accepts exactly these keys on create.
  static Map<String, Object?> newUserDoc(User user, {String? name}) {
    final email = user.email ?? '';
    final card = _cardFor(user, name: name);
    return {
      ...card.toFirestore(),
      'email': email,
      'emailDomain': email.contains('@')
          ? '@${email.split('@').last.toLowerCase()}'
          : '',
      'createdAt': FieldValue.serverTimestamp(),
      'roleTag': '',
      'campus': '',
      'program': '',
      'bio': '',
    };
  }

  static UserModel _cardFor(User user, {String? name}) {
    final email = user.email ?? '';
    final displayName = (name ?? user.displayName ?? '').trim();
    final fullName = displayName.isEmpty ? email.split('@').first : displayName;
    return UserModel(
      id: user.uid,
      name: fullName.length > AppSizes.nameMaxLength
          ? fullName.substring(0, AppSizes.nameMaxLength)
          : fullName,
      handle: Validators.handleFromEmail(email),
      avatarPath: user.photoURL,
    );
  }

  static AuthAccount _toAccount(User user) => AuthAccount(
    id: user.uid,
    email: user.email ?? '',
    method: _methodOf(user),
    isEmailVerified: user.emailVerified,
  );

  static AuthMethod _methodOf(User user) =>
      user.providerData.any((info) => info.providerId == 'google.com')
      ? AuthMethod.google
      : AuthMethod.password;

  static void _requireAluEmail(String email) {
    if (!Validators.isAllowedEmail(email.trim())) {
      throw const AuthFailure(AuthFailureCode.domainNotAllowed);
    }
  }

  static Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (error) {
      throw AuthFailure.from(error);
    }
  }
}
