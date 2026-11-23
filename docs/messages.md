# Messages

One-to-one chat between ALU students.

## Data model

- Conversation id: the two user ids sorted and joined with `_` (`uidA_uidB`), so two people never get duplicate chats.
- `conversations/{id}`: `participantIds`, `lastMessage`, `updatedAt`, `unreadCounts`, `mutedBy`.
- `conversations/{id}/messages/{messageId}`: immutable once sent.
- Sending writes the message and updates `lastMessage`, `updatedAt` and the other person's unread count in one batch.
- Opening a chat sets your own unread count to 0.
