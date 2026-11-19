// Switching tabs from outside the shell.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/shared/widgets/navigation/main_shell.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('the shell switches tab on request', (tester) async {
    final requests = ValueNotifier<int?>(null);
    addTearDown(requests.dispose);
    await pumpScreen(
      tester,
      MainShell(
        tabRequests: requests,
        tabs: [
          for (final name in ['Home', 'Market', 'Explore', 'Messages', 'Me'])
            Center(child: Text('$name tab')),
        ],
      ),
    );
    expect(find.text('Home tab'), findsOneWidget);

    requests.value = 1;
    await tester.pumpAndSettle();
    expect(find.text('Market tab'), findsOneWidget);
    expect(requests.value, isNull);
  });
}
