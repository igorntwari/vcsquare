# Messages

One-to-one chat between ALU students.

## Data model

- Conversation id: the two user ids sorted and joined with `_` (`uidA_uidB`), so two people never get duplicate chats.
- `conversations/{id}`: `participantIds`, `lastMessage`, `updatedAt`, `unreadCounts`, `mutedBy`.
- `conversations/{id}/messages/{messageId}`: immutable once sent.
- Sending writes the message and updates `lastMessage`, `updatedAt` and the other person's unread count in one batch.
- Opening a chat sets your own unread count to 0.

## Mute, block and read ticks

- Mute adds your uid to `mutedBy` on the conversation.
- Block writes `users/{uid}/blocks/{blockedUid}` and hides that chat from your inbox. The other person still sees it.
- The inbox tick turns into a double tick once the other person's unread count is 0. Single bubbles stay on one tick because messages are immutable.

## Try it on two accounts

1. Run with `--dart-define=USE_FIREBASE=true --dart-define=USE_EMULATORS=true` on two devices.
2. Sign in as two ALU accounts.
3. On A, tap New chat, pick B and send a message.
4. On B, the chat appears with an unread badge. Opening it clears the badge.
