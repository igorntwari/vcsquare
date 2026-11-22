// Saved posts and blocks were added after the live rules were last
// deployed. Until the rules catch up, Home and Messages must still load.

// The stubs below stand in for Firestore classes that are sealed against
// outside implementations; that's fine for a test double.
// ignore_for_file: subtype_of_sealed_class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/data/repositories/firebase/user_lookup.dart';
import 'package:vsquare/data/repositories/posts/firebase_posts_repository.dart';

typedef _Json = Map<String, dynamic>;

// A Firestore whose rules refuse every users/{uid}/{subcollection} read
// with [code], the way the live project does for paths it has no rule for.
class _RefusingFirestore extends Fake implements FirebaseFirestore {
  _RefusingFirestore(this.code);
  final String code;

  @override
  CollectionReference<_Json> collection(String path) => _Users(code);
}

class _Users extends Fake implements CollectionReference<_Json> {
  _Users(this.code);
  final String code;

  @override
  DocumentReference<_Json> doc([String? path]) => _User(code);
}

class _User extends Fake implements DocumentReference<_Json> {
  _User(this.code);
  final String code;

  @override
  CollectionReference<_Json> collection(String path) => _Refused(code);
}

class _Refused extends Fake implements CollectionReference<_Json> {
  _Refused(this.code);
  final String code;

  @override
  Future<QuerySnapshot<_Json>> get([GetOptions? options]) =>
      Future.error(FirebaseException(plugin: 'cloud_firestore', code: code));
}

void main() {
  test('a refused optional list reads as empty', () async {
    final db = _RefusingFirestore('permission-denied');
    expect(await readOptionalIdSet(db, 'amara', 'blocks'), isEmpty);
  });

  test('saved posts read as empty when the rules refuse them', () async {
    final repo = FirebasePostsRepository(
      _RefusingFirestore('permission-denied'),
    );
    expect(await repo.fetchSavedPostIds('amara'), isEmpty);
  });

  test('other errors, like being offline, still surface', () async {
    final db = _RefusingFirestore('unavailable');
    expect(
      readOptionalIdSet(db, 'amara', 'blocks'),
      throwsA(isA<FirebaseException>()),
    );
  });
}
