// Each main screen renders its sample data through the repositories.
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/data/models/post_model.dart';
import 'package:vsquare/data/repositories/posts/posts_repository.dart';
import 'package:vsquare/data/repositories/posts/sample_posts_repository.dart';
import 'package:vsquare/data/repositories/repository_providers.dart';
import 'package:vsquare/features/explore/screens/explore_screen.dart';
import 'package:vsquare/features/home/screens/home_screen.dart';
import 'package:vsquare/features/market/screens/market_screen.dart';
import 'package:vsquare/features/profile/screens/profile_screen.dart';
import 'package:vsquare/shared/widgets/feedback/error_state.dart';

import '../helpers/test_app.dart';

// A posts repository whose feed always fails.
class _FailingPosts extends SamplePostsRepository implements PostsRepository {
  @override
  Future<List<PostModel>> fetchFeed() => Future.error(StateError('offline'));
}

void main() {
  setUpAll(loadAppFonts);

  testWidgets('Home shows the pinned announcement', (tester) async {
    await pumpScreen(tester, const HomeScreen());
    expect(find.textContaining('Term 1 course registration'), findsOneWidget);
  });

  testWidgets('Home shows an error state when the feed fails', (tester) async {
    await pumpScreen(
      tester,
      const HomeScreen(),
      overrides: [postsRepositoryProvider.overrideWithValue(_FailingPosts())],
    );
    expect(find.byType(ErrorState), findsOneWidget);
  });

  testWidgets('Market shows categories and listings', (tester) async {
    await pumpScreen(tester, const MarketScreen());
    expect(find.text('Electronics'), findsOneWidget);
    expect(find.text('8 Categories'), findsOneWidget);
    expect(find.text('MacBook Air M1 2020'), findsOneWidget);
  });

  testWidgets('Explore shows trending topics and official handles', (
    tester,
  ) async {
    await pumpScreen(tester, const ExploreScreen());
    expect(find.text('#ALUHackathon2026'), findsOneWidget);
    expect(find.text('ALU Registry'), findsOneWidget);
  });

  testWidgets('Profile shows the signed-in student', (tester) async {
    await pumpScreen(tester, const ProfileScreen());
    expect(find.text('Amara Kamau'), findsWidgets);
  });
}
