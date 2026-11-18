// Shared widget-test setup.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpScreen(
  WidgetTester tester,
  Widget screen, {
  List overrides = const [],
}) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [...overrides],
      child: MaterialApp(home: Scaffold(body: screen)),
    ),
  );
  // Let the sample repositories' futures complete.
  await tester.pump();
  await tester.pump();
}

// Tests otherwise use a wide placeholder font, which makes rows overflow
// that fit fine on a phone. Load the real fonts so layout matches the app.
Future<void> loadAppFonts() async {
  const families = {
    'PlusJakartaSans': ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold'],
    'DMSans': ['Regular', 'Medium', 'SemiBold', 'Bold'],
  };
  for (final MapEntry(key: family, value: weights) in families.entries) {
    final loader = FontLoader(family);
    for (final weight in weights) {
      loader.addFont(rootBundle.load('assets/fonts/$family-$weight.ttf'));
    }
    await loader.load();
  }
}
