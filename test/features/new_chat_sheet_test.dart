// NewChatSheet: filtering students and picking one.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/data/models/user_model.dart';
import 'package:vsquare/features/messages/widgets/new_chat_sheet.dart';

const _amara = UserModel(id: 'amara', name: 'Amara Kamau', handle: '@amara.k');
const _kofi = UserModel(id: 'kofi', name: 'Kofi Mensah', handle: '@kofi.codes');

// Opens the sheet from a button and reports what it returned.
Future<void> _openSheet(
  WidgetTester tester, {
  required void Function(UserModel?) onResult,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () async {
                final picked = await showModalBottomSheet<UserModel>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const NewChatSheet(people: [_amara, _kofi]),
                );
                onResult(picked);
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('typing a name filters the student list', (tester) async {
    await _openSheet(tester, onResult: (_) {});
    expect(find.text('Amara Kamau'), findsOneWidget);
    expect(find.text('Kofi Mensah'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'kofi');
    await tester.pump();

    expect(find.text('Kofi Mensah'), findsOneWidget);
    expect(find.text('Amara Kamau'), findsNothing);
  });

  testWidgets('search also matches the handle', (tester) async {
    await _openSheet(tester, onResult: (_) {});

    await tester.enterText(find.byType(TextField), '@amara');
    await tester.pump();

    expect(find.text('Amara Kamau'), findsOneWidget);
    expect(find.text('Kofi Mensah'), findsNothing);
  });
  testWidgets('shows a message when nobody matches', (tester) async {
    await _openSheet(tester, onResult: (_) {});

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump();

    expect(find.text('No students found'), findsOneWidget);
  });}

