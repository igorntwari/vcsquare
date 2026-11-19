// Students on campus, following students, and the profile page.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/core/constants/app_strings.dart';
import 'package:vsquare/data/dummy/dummy_users.dart';
import 'package:vsquare/data/models/profile_edit_model.dart';
import 'package:vsquare/data/models/profile_model.dart';
import 'package:vsquare/data/repositories/follow/sample_follow_repository.dart';
import 'package:vsquare/data/repositories/profile/profile_repository.dart';
import 'package:vsquare/data/repositories/profile/sample_profile_repository.dart';
import 'package:vsquare/data/repositories/repository_providers.dart';
import 'package:vsquare/features/explore/widgets/students_on_campus_section.dart';
import 'package:vsquare/features/profile/screens/profile_screen.dart';
import 'package:vsquare/features/profile/screens/student_profile_screen.dart';

import '../helpers/test_app.dart';

// Every id returns Kofi, with nothing filled in beyond his name.
class _KofiProfiles implements ProfileRepository {
  @override
  Future<ProfileModel> fetchProfile(String userId) async => ProfileModel(
    user: dummyUsers.firstWhere((user) => user.id == 'u_kofi'),
    emailDomain: '@alustudent.com',
    roleTag: '',
    campus: '',
    program: '',
    bio: '',
    followerCount: 0,
    followingCount: 0,
    recognitionTitle: '',
    recognitionSubtitle: '',
  );

  @override
  Future<void> updateProfile(String userId, ProfileEdit edit) async {}
}

Finder _stat(String label) =>
    find.ancestor(of: find.text(label), matching: find.byType(Column));

String _statValue(WidgetTester tester, String label) => tester
    .widgetList<Text>(
      find.descendant(of: _stat(label).first, matching: find.byType(Text)),
    )
    .first
    .data!;

void main() {
  setUpAll(loadAppFonts);

  late SampleFollowRepository follows;

  setUp(() => follows = SampleFollowRepository());

  testWidgets('students on campus can be followed and opened', (tester) async {
    String? opened;
    await pumpScreen(
      tester,
      SingleChildScrollView(
        child: StudentsOnCampusSection(onOpenStudent: (s) => opened = s.id),
      ),
      overrides: [followRepositoryProvider.overrideWithValue(follows)],
    );
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.studentsOnCampus), findsOneWidget);
    expect(find.text(dummyCurrentUser.name), findsNothing);

    await tester.tap(find.text(AppStrings.follow).first);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.following), findsOneWidget);
    expect(await follows.watchFollowingCount(dummyCurrentUser.id).first, 1);

    await tester.tap(find.textContaining('@').first);
    await tester.pumpAndSettle();
    expect(opened, isNotNull);
  });

  testWidgets('following a student updates their follower count', (
    tester,
  ) async {
    await pumpScreen(
      tester,
      const StudentProfileScreen(userId: 'u_kofi'),
      overrides: [
        followRepositoryProvider.overrideWithValue(follows),
        profileRepositoryProvider.overrideWithValue(_KofiProfiles()),
      ],
    );
    await tester.pumpAndSettle();
    expect(_statValue(tester, AppStrings.statFollowers), '0');

    await tester.tap(find.text(AppStrings.follow));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.following), findsWidgets);
    expect(_statValue(tester, AppStrings.statFollowers), '1');

    await tester.tap(find.text(AppStrings.following).first);
    await tester.pumpAndSettle();
    expect(_statValue(tester, AppStrings.statFollowers), '0');
  });

  testWidgets('empty profile fields are hidden and the handle shows', (
    tester,
  ) async {
    await pumpScreen(
      tester,
      const StudentProfileScreen(userId: 'u_kofi'),
      overrides: [
        followRepositoryProvider.overrideWithValue(follows),
        profileRepositoryProvider.overrideWithValue(_KofiProfiles()),
      ],
    );
    await tester.pumpAndSettle();
    final kofi = dummyUsers.firstWhere((user) => user.id == 'u_kofi');
    expect(find.text(kofi.handle), findsOneWidget);
    expect(find.byIcon(Icons.school_outlined), findsNothing);
  });

  testWidgets('my following count is live', (tester) async {
    await pumpScreen(
      tester,
      const ProfileScreen(),
      overrides: [
        followRepositoryProvider.overrideWithValue(follows),
        profileRepositoryProvider.overrideWithValue(SampleProfileRepository()),
      ],
    );
    await tester.pumpAndSettle();
    expect(_statValue(tester, AppStrings.statFollowing), '0');

    await follows.setFollowingStudent(
      userId: dummyCurrentUser.id,
      studentId: 'u_kofi',
      following: true,
    );
    await tester.pumpAndSettle();
    expect(_statValue(tester, AppStrings.statFollowing), '1');
  });
}
