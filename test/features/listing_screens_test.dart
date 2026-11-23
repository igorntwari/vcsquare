// Listing detail (buyer and owner) and the preview before publishing.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/core/constants/app_strings.dart';
import 'package:vsquare/data/dummy/dummy_listings.dart';
import 'package:vsquare/data/models/listing_model.dart';
import 'package:vsquare/features/market/models/listing_draft.dart';
import 'package:vsquare/features/market/screens/listing_detail_screen.dart';
import 'package:vsquare/features/market/screens/listing_preview_screen.dart';

import '../helpers/test_app.dart';

final _listing = dummyListings.first;

// The detail screen closes itself after an owner action, so open it on top
// of another page, as the Market tab does.
Future<void> _openDetail(
  WidgetTester tester,
  ListingDetailScreen screen,
) async {
  await pumpScreen(
    tester,
    Builder(
      builder: (context) => TextButton(
        onPressed: () =>
            Navigator.of(context)
                .push(MaterialPageRoute<void>(builder: (_) => screen)),
        child: const Text('open'),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

Future<void> _ownerAction(WidgetTester tester, String action) async {
  await tester.tap(find.byType(PopupMenuButton<String>));
  await tester.pumpAndSettle();
  await tester.tap(find.text(action));
  await tester.pumpAndSettle();
}

ListingDraft _draft() => const ListingDraft(
  title: 'Desk lamp',
  description: '',
  priceRwf: 15000,
  categoryId: 'furniture',
  categoryName: 'Furniture',
  condition: ListingCondition.good,
  pickupHubId: 'hub_library',
  pickupHubName: 'ALU Library Foyer',
  negotiable: true,
  photoUrls: [
    'assets/images/listings/macbook_air.jpg',
    'assets/images/listings/leather_jacket.jpg',
  ],
);

void main() {
  setUpAll(loadAppFonts);

  group('listing detail', () {
    testWidgets('a buyer can message the seller', (tester) async {
      var messaged = false;
      await pumpScreen(
        tester,
        ListingDetailScreen(
          listing: _listing,
          onMessageSeller: () => messaged = true,
        ),
      );

      expect(find.text(_listing.title), findsWidgets);
      expect(find.byType(PopupMenuButton<String>), findsNothing);

      await tester.ensureVisible(find.text(AppStrings.messageSeller));
      await tester.tap(find.text(AppStrings.messageSeller));
      expect(messaged, isTrue);
    });

    testWidgets('the owner can mark it sold', (tester) async {
      var toggled = false;
      await _openDetail(
        tester,
        ListingDetailScreen(
          listing: _listing,
          isOwner: true,
          onToggleStatus: () async => toggled = true,
        ),
      );

      await _ownerAction(tester, AppStrings.markAsSold);
      expect(toggled, isTrue);
      expect(find.text(AppStrings.listingMarkedSold), findsOneWidget);
    });

    testWidgets('deleting asks first', (tester) async {
      var deleted = false;
      await _openDetail(
        tester,
        ListingDetailScreen(
          listing: _listing,
          isOwner: true,
          onDelete: () async => deleted = true,
        ),
      );

      await _ownerAction(tester, AppStrings.deleteListing);
      expect(find.text(AppStrings.confirmDeleteListing), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, AppStrings.cancel));
      await tester.pumpAndSettle();
      expect(deleted, isFalse);

      await _ownerAction(tester, AppStrings.deleteListing);
      await tester.tap(
        find.widgetWithText(TextButton, AppStrings.deleteListing),
      );
      await tester.pumpAndSettle();
      expect(deleted, isTrue);
      expect(find.text(AppStrings.listingDeleted), findsOneWidget);
    });

    testWidgets('a failed status change is reported', (tester) async {
      await _openDetail(
        tester,
        ListingDetailScreen(
          listing: _listing,
          isOwner: true,
          onToggleStatus: () => Future.error(StateError('offline')),
        ),
      );

      await _ownerAction(tester, AppStrings.markAsSold);
      expect(find.text(AppStrings.saveFailed), findsOneWidget);
    });
  });

  group('listing preview', () {
    testWidgets('shows the draft and publishes it', (tester) async {
      var published = false;
      await pumpScreen(
        tester,
        ListingPreviewScreen(
          draft: _draft(),
          onPublish: () async => published = true,
        ),
      );

      expect(find.text('Desk lamp'), findsWidgets);
      expect(find.text(AppStrings.previewPhotoCount(2)), findsOneWidget);
      expect(find.text(AppStrings.noListingDescription), findsOneWidget);

      await tester.ensureVisible(find.text(AppStrings.publishListing));
      await tester.tap(find.text(AppStrings.publishListing));
      await tester.pumpAndSettle();
      expect(published, isTrue);
    });

    testWidgets('a failed publish is reported', (tester) async {
      await pumpScreen(
        tester,
        ListingPreviewScreen(
          draft: _draft(),
          isEditing: true,
          onPublish: () => Future.error(StateError('offline')),
        ),
      );

      await tester.ensureVisible(find.text(AppStrings.saveChanges));
      await tester.tap(find.text(AppStrings.saveChanges));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.saveFailed), findsOneWidget);
    });
  });
}
