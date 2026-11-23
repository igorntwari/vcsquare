import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/data/models/message_model.dart';
import 'package:vsquare/data/models/user_model.dart';
import 'package:vsquare/data/repositories/chats/firebase_chats_repository.dart';

void main() {
  late FakeFirebaseFirestore db;
  late FirebaseChatsRepository repo;

  const amara = UserModel(id: 'amara', name: 'Amara Kamau', handle: '@amara.k');

  const kofi = UserModel(
    id: 'kofi',
    name: 'Kofi Mensah',
    handle: '@kofi.codes',
  );

  setUp(() async {
    db = FakeFirebaseFirestore();
    repo = FirebaseChatsRepository(db);

    await db.doc('users/amara').set(amara.toFirestore());
    await db.doc('users/kofi').set(kofi.toFirestore());
  });

  group('openConversation', () {
    test('creates a conversation with sorted participant IDs', () async {
      final chat = await repo.openConversation(userId: 'kofi', other: amara);

      expect(chat.id, 'amara_kofi');
      expect(chat.participant.id, 'amara');
    });

    test('both participants share one conversation document', () async {
      await repo.openConversation(userId: 'amara', other: kofi);
      await repo.openConversation(userId: 'kofi', other: amara);

      final docs = await db.collection('conversations').get();

      expect(docs.docs, hasLength(1));
      expect(docs.docs.single.data()['participantIds'], ['amara', 'kofi']);
    });

    test('does not overwrite an existing conversation', () async {
      await repo.openConversation(userId: 'amara', other: kofi);

      await repo.sendMessage(
        conversationId: 'amara_kofi',
        senderId: 'amara',
        text: 'Hello Kofi',
      );

      await repo.openConversation(userId: 'kofi', other: amara);

      final doc = await db.doc('conversations/amara_kofi').get();

      expect(doc.data()!['lastMessage']['text'], 'Hello Kofi');
    });
  });

  group('sendMessage', () {
    setUp(() async {
      await repo.openConversation(userId: 'amara', other: kofi);
    });

    test('stores a message and updates the conversation', () async {
      await repo.sendMessage(
        conversationId: 'amara_kofi',
        senderId: 'amara',
        text: '  Hello Kofi  ',
      );

      final messages = await repo.watchMessages('amara_kofi').first;

      expect(messages, hasLength(1));
      expect(messages.single.text, 'Hello Kofi');
      expect(messages.single.senderId, 'amara');

      final doc = await db.doc('conversations/amara_kofi').get();

      expect(doc.data()!['lastMessage']['text'], 'Hello Kofi');
      expect(doc.data()!['unreadCounts']['kofi'], 1);
      expect(doc.data()!['unreadCounts']['amara'], 0);
    });

    test('ignores blank messages', () async {
      await repo.sendMessage(
        conversationId: 'amara_kofi',
        senderId: 'amara',
        text: '   ',
      );

      expect(await repo.watchMessages('amara_kofi').first, isEmpty);
    });

    test('truncates messages longer than 2000 characters', () async {
      final longText = 'a' * 2100;

      await repo.sendMessage(
        conversationId: 'amara_kofi',
        senderId: 'amara',
        text: longText,
      );

      final messages = await repo.watchMessages('amara_kofi').first;

      expect(messages.single.text.length, 2000);
    });

    test('increments unread count for every message', () async {
      for (final text in ['one', 'two', 'three']) {
        await repo.sendMessage(
          conversationId: 'amara_kofi',
          senderId: 'amara',
          text: text,
        );
      }

      final doc = await db.doc('conversations/amara_kofi').get();

      expect(doc.data()!['unreadCounts']['kofi'], 3);
    });
  });

  group('markRead', () {
    setUp(() async {
      await repo.openConversation(userId: 'amara', other: kofi);
    });

    test('clears the reader unread count', () async {
      await repo.sendMessage(
        conversationId: 'amara_kofi',
        senderId: 'amara',
        text: 'Hello',
      );

      await repo.markRead(conversationId: 'amara_kofi', userId: 'kofi');

      final doc = await db.doc('conversations/amara_kofi').get();

      expect(doc.data()!['unreadCounts']['kofi'], 0);
    });

    test('does not clear the other participant unread count', () async {
      await repo.sendMessage(
        conversationId: 'amara_kofi',
        senderId: 'amara',
        text: 'Hello',
      );

      await repo.markRead(conversationId: 'amara_kofi', userId: 'amara');

      final doc = await db.doc('conversations/amara_kofi').get();

      expect(doc.data()!['unreadCounts']['kofi'], 1);
    });
  });

  group('watchConversations', () {
    setUp(() async {
      await repo.openConversation(userId: 'amara', other: kofi);
    });

    test('shows a conversation after its first message', () async {
      await repo.sendMessage(
        conversationId: 'amara_kofi',
        senderId: 'amara',
        text: 'Are you free?',
      );

      final inbox = await repo.watchConversations('kofi').first;

      expect(inbox, hasLength(1));
      expect(inbox.single.participant.id, 'amara');
      expect(inbox.single.lastMessage.text, 'Are you free?');
      expect(inbox.single.unreadCount, 1);
    });

    test('hides conversations with blocked users', () async {
      await repo.sendMessage(
        conversationId: 'amara_kofi',
        senderId: 'kofi',
        text: 'Hello',
      );

      expect(await repo.watchConversations('amara').first, hasLength(1));

      await repo.blockUser(userId: 'amara', blockedId: 'kofi');

      expect(await repo.watchConversations('amara').first, isEmpty);

      expect(await repo.watchConversations('kofi').first, hasLength(1));
    });

    test('derives read status from the unread count', () async {
      await repo.sendMessage(
        conversationId: 'amara_kofi',
        senderId: 'amara',
        text: 'Seen?',
      );

      var inbox = await repo.watchConversations('amara').first;

      expect(inbox.single.lastMessage.status, MessageStatus.sent);

      await repo.markRead(conversationId: 'amara_kofi', userId: 'kofi');

      inbox = await repo.watchConversations('amara').first;

      expect(inbox.single.lastMessage.status, MessageStatus.read);
    });
  });

  group('mute and block', () {
    setUp(() async {
      await repo.openConversation(userId: 'amara', other: kofi);
    });

    test('setMuted adds and removes only the given user', () async {
      await repo.setMuted(
        conversationId: 'amara_kofi',
        userId: 'amara',
        muted: true,
      );

      expect(
        await repo
            .watchMuted(conversationId: 'amara_kofi', userId: 'amara')
            .first,
        isTrue,
      );

      expect(
        await repo
            .watchMuted(conversationId: 'amara_kofi', userId: 'kofi')
            .first,
        isFalse,
      );

      await repo.setMuted(
        conversationId: 'amara_kofi',
        userId: 'amara',
        muted: false,
      );

      expect(
        await repo
            .watchMuted(conversationId: 'amara_kofi', userId: 'amara')
            .first,
        isFalse,
      );
    });

    test('blockUser creates the other user block document', () async {
      await repo.blockUser(userId: 'amara', blockedId: 'kofi');

      final block = await db.doc('users/amara/blocks/kofi').get();

      expect(block.exists, isTrue);
    });
  });

  group('fetchPeople', () {
    test('returns other students but excludes the caller', () async {
      final people = await repo.fetchPeople('amara');

      expect(people.map((person) => person.id), ['kofi']);
    });
  });
}
