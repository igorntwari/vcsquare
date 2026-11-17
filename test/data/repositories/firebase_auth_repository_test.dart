// FirebaseAuthRepository with mocked Auth and Firestore. Google isn't covered.
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:vsquare/data/models/auth_account_model.dart';
import 'package:vsquare/data/repositories/auth/auth_failure.dart';
import 'package:vsquare/data/repositories/auth/firebase_auth_repository.dart';

const _email = 'n.uwase@alustudent.com';
const _password = 'campus2026';

void main() {
  late FakeFirebaseFirestore db;

  setUp(() => db = FakeFirebaseFirestore());

  Matcher failsWith(AuthFailureCode code) => throwsA(
    isA<AuthFailure>().having((failure) => failure.code, 'code', code),
  );

  group('sign up', () {
    test('creates the profile and leaves the account unverified', () async {
      final auth = MockFirebaseAuth(verifyEmailAutomatically: false);
      final repo = FirebaseAuthRepository(auth, db);

      await repo.signUpWithEmail(
        name: ' Nadia Uwase ',
        email: _email,
        password: _password,
      );

      final uid = auth.currentUser!.uid;
      final doc = await db.collection('users').doc(uid).get();
      expect(doc['name'], 'Nadia Uwase');
      expect(doc['handle'], '@n.uwase');
      expect(doc['email'], _email);
      expect(doc['emailDomain'], '@alustudent.com');
      expect(doc['type'], 'student');
      expect(doc['isVerified'], isFalse);
      expect(doc.data()!.containsKey('followerCount'), isFalse);
      expect(doc.data()!.containsKey('recognitionTitle'), isFalse);

      expect(auth.currentUser!.emailVerified, isFalse);
    });

    test('an unverified email account must verify first', () async {
      final auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'u1', email: _email, isEmailVerified: false),
      );
      final account = await FirebaseAuthRepository(
        auth,
        db,
      ).watchAccount().firstWhere((account) => account != null);
      expect(account!.method, AuthMethod.password);
      expect(account.needsEmailVerification, isTrue);
    });

    test('turns away non-ALU emails before calling Firebase', () async {
      final auth = MockFirebaseAuth();
      final repo = FirebaseAuthRepository(auth, db);

      await expectLater(
        repo.signUpWithEmail(
          name: 'Outsider',
          email: 'outsider@gmail.com',
          password: _password,
        ),
        failsWith(AuthFailureCode.domainNotAllowed),
      );
      expect(auth.currentUser, isNull);
    });

    test('reports an email that is already registered', () async {
      final auth = MockFirebaseAuth();
      whenCalling(Invocation.method(#createUserWithEmailAndPassword, null))
          .on(auth)
          .thenThrow(FirebaseAuthException(code: 'email-already-in-use'));
      final repo = FirebaseAuthRepository(auth, db);

      await expectLater(
        repo.signUpWithEmail(name: 'Nadia', email: _email, password: _password),
        failsWith(AuthFailureCode.emailInUse),
      );
    });
  });

  group('sign in', () {
    test('signs in and recreates a missing profile', () async {
      final auth = MockFirebaseAuth(
        mockUser: MockUser(uid: 'u1', email: _email, displayName: 'Nadia'),
      );
      final repo = FirebaseAuthRepository(auth, db);

      await repo.signInWithEmail(email: _email, password: _password);

      expect(auth.currentUser!.uid, 'u1');
      expect((await db.collection('users').doc('u1').get()).exists, isTrue);
    });

    test('keeps an existing profile as it is', () async {
      await db.collection('users').doc('u1').set({
        'name': 'Edited Name',
        'handle': '@edited',
      });
      final auth = MockFirebaseAuth(
        mockUser: MockUser(uid: 'u1', email: _email, displayName: 'Nadia'),
      );
      await FirebaseAuthRepository(
        auth,
        db,
      ).signInWithEmail(email: _email, password: _password);

      final doc = await db.collection('users').doc('u1').get();
      expect(doc['name'], 'Edited Name');
    });

    test('wrong password becomes a friendly failure', () async {
      final auth = MockFirebaseAuth();
      whenCalling(Invocation.method(#signInWithEmailAndPassword, null))
          .on(auth)
          .thenThrow(FirebaseAuthException(code: 'wrong-password'));

      await expectLater(
        FirebaseAuthRepository(
          auth,
          db,
        ).signInWithEmail(email: _email, password: 'nope'),
        failsWith(AuthFailureCode.invalidCredential),
      );
    });

    test('watchCurrentUser follows the profile document', () async {
      final auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'u1', email: _email),
      );
      await db.collection('users').doc('u1').set({
        'name': 'Nadia Uwase',
        'handle': '@nadia',
      });
      final user = await FirebaseAuthRepository(
        auth,
        db,
      ).watchCurrentUser().firstWhere((user) => user != null);
      expect(user!.name, 'Nadia Uwase');
    });
  });

  group('password reset', () {
    test('an unknown email looks the same as a known one', () async {
      final auth = MockFirebaseAuth();
      whenCalling(Invocation.method(#sendPasswordResetEmail, null))
          .on(auth)
          .thenThrow(FirebaseAuthException(code: 'user-not-found'));

      await expectLater(
        FirebaseAuthRepository(auth, db).sendPasswordResetEmail(_email),
        completes,
      );
    });

    test('non-ALU emails are refused', () async {
      await expectLater(
        FirebaseAuthRepository(
          MockFirebaseAuth(),
          db,
        ).sendPasswordResetEmail('someone@yahoo.com'),
        failsWith(AuthFailureCode.domainNotAllowed),
      );
    });
  });

  test('sign out clears the account', () async {
    final auth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(uid: 'u1', email: _email),
    );
    await FirebaseAuthRepository(auth, db).signOut();
    expect(auth.currentUser, isNull);
  });

  group('delete account', () {
    late MockFirebaseAuth auth;

    setUp(() async {
      auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'u1', email: _email),
      );
      final users = db.collection('users');
      await users.doc('u1').set({'name': 'Nadia', 'handle': '@nadia'});
      await users.doc('u1').collection('likedPosts').doc('p1').set({});
      await users.doc('u1').collection('savedListings').doc('l9').set({});
      await users.doc('u1').collection('following').doc('h1').set({});
      await db.collection('posts').doc('p1').set({
        'authorId': 'other',
        'likeCount': 3,
      });
      await db.collection('posts').doc('mine').set({
        'authorId': 'u1',
        'likeCount': 0,
      });
      await db.collection('listings').doc('l1').set({'sellerId': 'u1'});
      await db.collection('listings').doc('l2').set({'sellerId': 'other'});
    });

    test('erases the profile, content and per-user data', () async {
      await FirebaseAuthRepository(auth, db).deleteAccount(password: _password);

      final users = db.collection('users');
      expect((await users.doc('u1').get()).exists, isFalse);
      expect(
        (await users.doc('u1').collection('likedPosts').get()).docs,
        isEmpty,
      );
      expect(
        (await users.doc('u1').collection('savedListings').get()).docs,
        isEmpty,
      );
      expect((await db.collection('posts').doc('mine').get()).exists, isFalse);
      expect((await db.collection('listings').doc('l1').get()).exists, isFalse);
      expect((await db.collection('listings').doc('l2').get()).exists, isTrue);
      expect((await db.collection('posts').doc('p1').get())['likeCount'], 2);
    });

    test('a wrong password deletes nothing', () async {
      whenCalling(Invocation.method(#reauthenticateWithCredential, null))
          .on(auth.currentUser!)
          .thenThrow(FirebaseAuthException(code: 'wrong-password'));

      await expectLater(
        FirebaseAuthRepository(auth, db).deleteAccount(password: 'nope'),
        failsWith(AuthFailureCode.invalidCredential),
      );
      expect((await db.collection('users').doc('u1').get()).exists, isTrue);
    });
  });
}
