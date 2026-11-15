// tool/seed/data must match the sample data the app ships with, and only
// use icon names the app knows. If this fails after editing the dummy data,
// update the JSON files (or the other way round).
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/core/constants/app_icons.dart';
import 'package:vsquare/data/dummy/dummy_categories.dart';
import 'package:vsquare/data/dummy/dummy_communities.dart';
import 'package:vsquare/data/dummy/dummy_official_handles.dart';
import 'package:vsquare/data/dummy/dummy_pickup_hubs.dart';

Map<String, dynamic> readSeed(String name) =>
    jsonDecode(File('tool/seed/data/$name.json').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  test('categories', () {
    final seed = readSeed('categories');
    expect(seed.keys, dummyCategories.map((c) => c.id));
    for (final c in dummyCategories) {
      expect(seed[c.id], c.toFirestore());
    }
  });

  test('pickupHubs', () {
    final seed = readSeed('pickupHubs');
    expect(seed.keys, dummyPickupHubs.map((h) => h.id));
    for (final h in dummyPickupHubs) {
      expect(seed[h.id], h.toFirestore());
    }
  });

  test('officialHandles', () {
    final seed = readSeed('officialHandles');
    expect(seed.keys, dummyOfficialHandles.map((h) => h.id));
    for (final h in dummyOfficialHandles) {
      expect(seed[h.id], h.toFirestore());
    }
  });

  test('communities (member previews are left empty in the seed)', () {
    final seed = readSeed('communities');
    expect(seed.keys, dummyCommunities.map((c) => c.id));
    for (final c in dummyCommunities) {
      expect(seed[c.id], {...c.toFirestore(), 'memberPreviewIds': <String>[]});
    }
  });

  test('every iconName is registered in AppIcons', () {
    for (final name in ['categories', 'pickupHubs', 'officialHandles']) {
      for (final doc in readSeed(name).values) {
        final iconName = (doc as Map<String, dynamic>)['iconName'] as String;
        expect(AppIcons.isKnown(iconName), isTrue, reason: '$name: $iconName');
      }
    }
  });
}
