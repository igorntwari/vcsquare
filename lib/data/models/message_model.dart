// Model representing a single chat message.

// Delivery state of a message the current user sent.
enum MessageStatus { sent, read }

class MessageModel {
  const MessageModel({
    required this.id,
    required this.text,
    required this.sentAt,
    required this.isMine,
    this.status = MessageStatus.read,
  });

  final String id;
  final String text;
  final DateTime sentAt;

  // True when the current user sent it.
  final bool isMine;

  // Only meaningful when [isMine] is true.
  final MessageStatus status;
}
