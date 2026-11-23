// Sell item form: required fields, drafts and editing a listing.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/core/constants/app_strings.dart';
import 'package:vsquare/data/dummy/dummy_listings.dart';
import 'package:vsquare/data/models/listing_model.dart';
import 'package:vsquare/data/repositories/repository_providers.dart';
import 'package:vsquare/features/market/screens/sell_item_screen.dart';

import '../helpers/test_app.dart';

// The form is a lazy list, so scroll to the top and then down to a widget.
Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  final list = find
      .byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      )
      .first;
  await tester.drag(list, const Offset(0, 5000));
  await tester.pumpAndSettle();
  await tester.scrollUntilVisible(finder, 200, scrollable: list);
  await tester.pumpAndSettle();
}

Future<void> _tapText(WidgetTester tester, String text) async {
  await _scrollTo(tester, find.text(text));
  await tester.tap(find.text(text).first);
  await tester.pumpAndSettle();
}

Future<void> _enter(WidgetTester tester, String hint, String text) async {
  final field = find.widgetWithText(TextField, hint);
  await _scrollTo(tester, field);
  await tester.enterText(field, text);
  await tester.pump();
}

// Waits for the last snack bar to close so it doesn't cover the buttons.
Future<void> _waitForSnackBar(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 5));
  await tester.pumpAndSettle();
}

Future<void> _expectProgress(WidgetTester tester, int percent) async {
  await _scrollTo(tester, find.textContaining('% complete'));
  expect(find.text(AppStrings.percentComplete(percent)), findsOneWidget);
}

void main() {
  setUpAll(loadAppFonts);

  testWidgets('an empty form cannot be previewed', (tester) async {
    var previewed = false;
    await pumpScreen(
      tester,
      SellItemScreen(onPreview: (_) => previewed = true),
    );

    expect(find.text(AppStrings.sellAnItem), findsOneWidget);
    expect(find.text(AppStrings.percentComplete(0)), findsOneWidget);

    await _tapText(tester, AppStrings.previewListing);
    expect(find.text(AppStrings.completeToPreview), findsOneWidget);
    expect(previewed, isFalse);
  });

  testWidgets('filling fields raises the progress and quick adds append', (
    tester,
  ) async {
    await pumpScreen(tester, const SellItemScreen());

    await _enter(tester, AppStrings.listingTitleHint, 'Desk lamp');
    await _tapText(tester, 'Furniture');
    await _tapText(tester, AppStrings.conditionLikeNew);
    await _tapText(tester, 'ALU Library Foyer');
    await _expectProgress(tester, 57);

    await _tapText(tester, '+ ${AppStrings.quickAddWarranty}');
    expect(find.textContaining(AppStrings.quickAddWarranty), findsWidgets);
    await _expectProgress(tester, 71);
  });

  testWidgets('a saved draft can be loaded back into the form', (tester) async {
    final auth = await signedInSampleAuth();
    await pumpScreen(
      tester,
      // Drafts belong to a user.
      const WithSignedInUser(child: SellItemScreen()),
      overrides: [authRepositoryProvider.overrideWithValue(auth)],
    );

    await _tapText(tester, AppStrings.drafts);
    expect(find.text(AppStrings.noDraftsSaved), findsOneWidget);
    await _waitForSnackBar(tester);

    await _enter(tester, AppStrings.listingTitleHint, 'Desk lamp');
    await _tapText(tester, AppStrings.saveDraft);
    expect(find.text(AppStrings.draftSaved), findsOneWidget);
    await _waitForSnackBar(tester);

    await _enter(tester, AppStrings.listingTitleHint, '');
    await _tapText(tester, AppStrings.drafts);
    await tester.tap(find.widgetWithText(ListTile, 'Desk lamp'));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.draftLoaded), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Desk lamp'), findsOneWidget);
  });

  testWidgets('editing a listing starts with its details filled in', (
    tester,
  ) async {
    final listing = dummyListings.first.copyWith(pickupHubId: 'hub_library');
    await pumpScreen(tester, SellItemScreen(initialListing: listing));

    expect(find.text(AppStrings.editListing), findsOneWidget);
    expect(find.widgetWithText(TextField, listing.title), findsOneWidget);
    await _expectProgress(tester, 100);
    expect(listing.condition, ListingCondition.likeNew);
  });
}
