// Model representing a campus event attached to a post.
import 'firestore_helpers.dart';

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

  // Stored inside the post document as posts/{id}.event.
  factory EventModel.fromFirestore(FirestoreMap data) => EventModel(
    title: readString(data['title']),
    startsAt: readDate(data['startsAt']),
    venue: readString(data['venue']),
    label: data['label'] as String?,
    note: data['note'] as String?,
    priceRwf: (data['priceRwf'] as num?)?.toInt(),
    showAsBanner: data['showAsBanner'] as bool? ?? true,
  );

  FirestoreMap toFirestore() => {
    'title': title,
    'startsAt': writeDate(startsAt),
    'venue': venue,
    'label': label,
    'note': note,
    'priceRwf': priceRwf,
    'showAsBanner': showAsBanner,
  };
}
