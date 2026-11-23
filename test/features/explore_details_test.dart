// Community and official account pages: details and join/follow.
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/core/constants/app_strings.dart';
import 'package:vsquare/data/dummy/dummy_communities.dart';
import 'package:vsquare/data/dummy/dummy_official_handles.dart';
import 'package:vsquare/features/explore/screens/community_detail_screen.dart';
import 'package:vsquare/features/explore/screens/official_handle_detail_screen.dart';

import '../helpers/test_app.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('joining a community flips the button', (tester) async {
    final community = dummyCommunities.first;
    var joins = 0;
    await pumpScreen(
      tester,
      CommunityDetailScreen(
        community: community,
        isJoined: false,
        onJoin: () => joins++,
      ),
    );

    expect(find.text(community.name), findsWidgets);
    expect(
      find.text(AppStrings.activeMembers(community.memberCount)),
      findsOneWidget,
    );

    await tester.tap(find.text(AppStrings.join));
    await tester.pump();
    expect(find.text(AppStrings.joined), findsOneWidget);
    expect(joins, 1);
  });

  testWidgets('following an official account flips the button', (tester) async {
    final handle = dummyOfficialHandles.first;
    var follows = 0;
    await pumpScreen(
      tester,
      OfficialHandleDetailScreen(
        handle: handle,
        isFollowing: true,
        onFollow: () => follows++,
      ),
    );

    expect(find.text(handle.name), findsWidgets);

    await tester.tap(find.text(AppStrings.following));
    await tester.pump();
    expect(find.text(AppStrings.follow), findsOneWidget);
    expect(follows, 1);
  });
}
