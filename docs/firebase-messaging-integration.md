# VCSquare Firebase Messaging Integration

## Current project setup

- Flutter application.
- Firebase Core initialized in lib/main.dart.
- Firebase Authentication dependency installed.
- Cloud Firestore dependency installed.
- Existing Firebase project: vcsquared-131f0.
- Firebase Android configuration exists.

## Current messaging architecture

Existing UI:
- lib/features/messages/screens/messages_screen.dart
- lib/features/messages/screens/chat_screen.dart
- lib/features/messages/widgets/chat_input_bar.dart
- lib/features/messages/widgets/message_bubble.dart

Existing models:
- lib/data/models/message_model.dart
- lib/data/models/conversation_model.dart
- lib/data/models/user_model.dart

Current limitation:
- MessagesScreen uses dummy conversations.
- ChatScreen stores sent messages locally.
- Real-time Firestore messaging is not implemented yet.

## Planned backend integration

1. Connect conversations to Cloud Firestore.
2. Implement real-time message streams.
3. Implement authenticated message sending.
4. Implement read receipts.
5. Integrate Firebase Cloud Messaging.
6. Implement Cloud Functions for notifications.
7. Implement follower and following count updates.
8. Implement safe account deletion and cleanup.

## Proposed Firestore structure

users/{uid}
users/{uid}/tokens/{token}
users/{uid}/followers/{followerUid}
users/{uid}/following/{followingUid}
users/{uid}/blocks/{blockedUid}

conversations/{conversationId}
conversations/{conversationId}/messages/{messageId}

## Important implementation requirements

- Use Firebase Authentication UIDs.
- Validate conversation participants.
- Enforce Firestore security rules.
- Prevent duplicate follower count updates.
- Respect muted conversations and blocked users.
- Avoid deleting shared conversations when deleting one account.
- Test Cloud Functions before deployment.

## Development branch

profile/messages

## Current status

Architecture inspected. Backend implementation and testing pending.
