// Comments sheet: empty state and adding a comment.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/core/constants/app_strings.dart';
import 'package:vsquare/data/dummy/dummy_posts.dart';
import 'package:vsquare/data/repositories/repository_providers.dart';
import 'package:vsquare/features/home/screens/post_comments_sheet.dart';

import '../helpers/test_app.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('a new comment is added and counted', (tester) async {
    final post = dummyPosts.firstWhere((post) => post.commentPreview == null);
    final count = post.commentCount;
    final auth = await signedInSampleAuth();
    await pumpScreen(
      tester,
      WithSignedInUser(child: PostCommentsSheet(post: post)),
      overrides: [authRepositoryProvider.overrideWithValue(auth)],
    );
    await tester.pumpAndSettle();

    expect(find.text('${AppStrings.commentsTitle} ($count)'), findsOneWidget);
    expect(find.text(AppStrings.noCommentsMessage), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, AppStrings.commentHint),
      'Count me in!',
    );
    await tester.pump();
    await tester.tap(find.byTooltip(AppStrings.send));
    await tester.pumpAndSettle();

    expect(find.text('Count me in!'), findsOneWidget);
    expect(
      find.text('${AppStrings.commentsTitle} (${count + 1})'),
      findsOneWidget,
    );
    expect(find.text(AppStrings.noCommentsMessage), findsNothing);
  });
}
