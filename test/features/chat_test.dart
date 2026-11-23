// One-to-one chat: thread, sending, muting and blocking.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/core/constants/app_strings.dart';
import 'package:vsquare/data/dummy/dummy_conversations.dart';
import 'package:vsquare/data/dummy/dummy_messages.dart';
import 'package:vsquare/data/repositories/repository_providers.dart';
import 'package:vsquare/features/messages/screens/chat_screen.dart';

import '../helpers/test_app.dart';

Future<void> _openChat(WidgetTester tester) async {
  final auth = await signedInSampleAuth();
  await pumpScreen(
    tester,
    WithSignedInUser(child: ChatScreen(conversation: dummyConversations.first)),
    overrides: [authRepositoryProvider.overrideWithValue(auth)],
  );
  await tester.pumpAndSettle();
}

Future<void> _choose(WidgetTester tester, String option) async {
  await tester.tap(find.byTooltip(AppStrings.moreOptions));
  await tester.pumpAndSettle();
  await tester.tap(find.text(option));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(loadAppFonts);

  testWidgets('shows the thread with the other student', (tester) async {
    await _openChat(tester);

    final conversation = dummyConversations.first;
    expect(find.text(conversation.participant.name), findsWidgets);
    expect(
      find.text(dummyMessages[conversation.id]!.first.text),
      findsOneWidget,
    );
  });

  testWidgets('a sent message appears in the thread', (tester) async {
    await _openChat(tester);

    final send = find.byTooltip(AppStrings.send);
    final sendButton = find.ancestor(
      of: send,
      matching: find.byType(IconButton),
    );
    expect(tester.widget<IconButton>(sendButton).onPressed, isNull);

    await tester.enterText(
      find.widgetWithText(TextField, AppStrings.messageHint),
      'Is it still available?',
    );
    await tester.pump();
    await tester.tap(send);
    await tester.pumpAndSettle();

    expect(find.text('Is it still available?'), findsOneWidget);
  });

  testWidgets('the chat can be muted', (tester) async {
    await _openChat(tester);

    await _choose(tester, AppStrings.muteChat);
    expect(find.text(AppStrings.chatMuted), findsOneWidget);
  });

  testWidgets('blocking asks first, then confirms', (tester) async {
    await _openChat(tester);

    await _choose(tester, AppStrings.blockUser);
    expect(find.text(AppStrings.blockConfirmTitle), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, AppStrings.blockUser));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.userBlocked), findsOneWidget);
  });
}
