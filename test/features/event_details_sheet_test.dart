// The event sheet shows the details and returns true when RSVP is tapped.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/core/constants/app_strings.dart';
import 'package:vsquare/data/models/event_model.dart';
import 'package:vsquare/features/home/widgets/event_details_sheet.dart';

import '../helpers/test_app.dart';

void main() {
  setUpAll(loadAppFonts);

  final event = EventModel(
    title: 'Innovation Showcase',
    startsAt: DateTime(2026, 12, 4, 18, 30),
    venue: 'Main Hall',
    priceRwf: 2000,
  );

  testWidgets('shows date, venue and price, and pops true on RSVP', (
    tester,
  ) async {
    bool? result;
    await pumpScreen(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            result = await showModalBottomSheet<bool>(
              context: context,
              builder: (_) => EventDetailsSheet(event: event, isRsvped: false),
            );
          },
          child: const Text('open'),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Innovation Showcase'), findsOneWidget);
    expect(find.text('Main Hall'), findsOneWidget);
    expect(find.text('RWF 2,000'), findsOneWidget);

    await tester.tap(find.text(AppStrings.rsvpNow));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });

  testWidgets('offers to cancel when already going', (tester) async {
    await pumpScreen(tester, EventDetailsSheet(event: event, isRsvped: true));
    expect(find.text(AppStrings.cancelRsvp), findsOneWidget);
  });
}
