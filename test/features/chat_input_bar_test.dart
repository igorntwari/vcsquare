// ChatInputBar: enabling send, trimming and clearing.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/features/messages/widgets/chat_input_bar.dart';

Future<List<String>> _pump(WidgetTester tester) async {
  final sent = <String>[];
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: ChatInputBar(onSend: sent.add))),
  );
  return sent;
}

void main() {
  testWidgets('send is disabled while the field is blank', (tester) async {
    await _pump(tester);
    await tester.enterText(find.byType(TextField), '   ');
    await tester.pump();

    final button = tester.widget<IconButton>(find.widgetWithIcon(IconButton, Icons.send));
    expect(button.onPressed, isNull);
  });

  testWidgets('sending passes trimmed text and clears the field',
      (tester) async {
    final sent = await _pump(tester);
    await tester.enterText(find.byType(TextField), '  hello  ');
    await tester.pump();
    await tester.tap(find.widgetWithIcon(IconButton, Icons.send));
    await tester.pump();

    expect(sent, ['hello']);
    expect(find.text('hello'), findsNothing);
  });
  testWidgets('the keyboard send action also sends', (tester) async {
    final sent = await _pump(tester);
    await tester.enterText(find.byType(TextField), 'hi');
    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pump();

    expect(sent, ['hi']);
  });}


