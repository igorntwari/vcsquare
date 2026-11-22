// Following students, and live follower/following counts.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/data/repositories/follow/firebase_follow_repository.dart';

void main() {
  late FakeFirebaseFirestore db;
  late FirebaseFollowRepository repo;

  setUp(() async {
    db = FakeFirebaseFirestore();
    repo = FirebaseFollowRepository(db);
    final users = db.collection('users');
    await users.doc('amara').set({
      'name': 'Amara',
      'handle': '@amara',
      'type': 'student',
      'createdAt': Timestamp.fromDate(DateTime(2026, 11, 1)),
    });
    await users.doc('kofi').set({
      'name': 'Kofi',
      'handle': '@kofi',
      'type': 'student',
      'createdAt': Timestamp.fromDate(DateTime(2026, 11, 3)),
    });
    await users.doc('registry').set({
      'name': 'Registry',
      'handle': '@registry',
      'type': 'official',
      'createdAt': Timestamp.fromDate(DateTime(2026, 11, 2)),
    });
  });

  test('students are newest first, without yourself or officials', () async {
    final students = await repo.fetchStudents(excludeUserId: 'amara');
    expect([for (final s in students) s.id], ['kofi']);
  });

  test('following a student writes its target and updates counts', () async {
    await repo.setFollowingStudent(
      userId: 'amara',
      studentId: 'kofi',
      following: true,
    );

    final doc = await db.doc('users/amara/following/kofi').get();
    expect(doc['targetId'], 'kofi');
    expect(doc['type'], 'user');
    expect(await repo.watchFollowingIds('amara').first, {'kofi'});
    expect(await repo.watchFollowingCount('amara').first, 1);
    expect(await repo.watchFollowerCount('kofi').first, 1);
    expect(await repo.watchFollowerCount('amara').first, 0);

    await repo.setFollowingStudent(
      userId: 'amara',
      studentId: 'kofi',
      following: false,
    );
    expect(await repo.watchFollowerCount('kofi').first, 0);
  });

  test('official handles count towards following', () async {
    await db.doc('users/amara/following/h_registry').set({'createdAt': 1});
    expect(await repo.watchFollowingCount('amara').first, 1);
  });
}
