// Small helpers shared by the models' Firestore read/write methods.
import 'package:cloud_firestore/cloud_firestore.dart';

typedef FirestoreMap = Map<String, dynamic>;

// Firestore returns Timestamps; tests and older docs may hold DateTimes.
DateTime readDate(Object? value) => switch (value) {
  Timestamp() => value.toDate(),
  DateTime() => value,
  String() => DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0),
  _ => DateTime.fromMillisecondsSinceEpoch(0),
};

Timestamp writeDate(DateTime value) => Timestamp.fromDate(value);

// Enums are stored by name so the database stays readable.
T readEnum<T extends Enum>(List<T> values, Object? name, T fallback) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  return fallback;
}

int readInt(Object? value) => (value as num?)?.toInt() ?? 0;

String readString(Object? value) => value as String? ?? '';

FirestoreMap? readMap(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : null;

List<String> readStringList(Object? value) =>
    value is List ? value.whereType<String>().toList() : const [];
