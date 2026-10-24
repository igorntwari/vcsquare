// Model representing a campus event attached to a post.
class EventModel {
  const EventModel({
    required this.title,
    required this.startsAt,
    required this.venue,
    this.label,
    this.note,
    this.priceRwf,
    this.showAsBanner = true,
  });

  final String title;
  final DateTime startsAt;
  final String venue;

  // Small uppercase kicker on the flyer, e.g. "ANNUAL SHOWCASE".
  final String? label;

  // Extra line on compact callouts, e.g. "Seats capped".
  final String? note;

  // Ticket price in Rwandan francs. Null means free entry.
  final int? priceRwf;

  // True: big navy flyer. False: compact callout row with an RSVP button.
  final bool showAsBanner;

  bool get isFree => priceRwf == null;
}
