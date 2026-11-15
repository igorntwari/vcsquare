// Model representing a single chat message.
import 'firestore_helpers.dart';

// Delivery state of a message.
enum MessageStatus { sent, read }

class MessageModel {
  const MessageModel({
    required this.id,
    required this.text,
    required this.sentAt,
    required this.senderId,
    this.status = MessageStatus.read,
  });

  final String id;
  final String text;
  final DateTime sentAt;

  // Compare with the signed-in user's id to tell which side it goes on.
  final String senderId;
  final MessageStatus status;

  bool isFrom(String userId) => senderId == userId;

  // conversations/{conversationId}/messages/{id}, and the lastMessage copy
  // inside the conversation document.
  factory MessageModel.fromFirestore(String id, FirestoreMap data) =>
      MessageModel(
        id: id,
        text: readString(data['text']),
        sentAt: readDate(data['sentAt']),
        senderId: readString(data['senderId']),
        status: readEnum(
          MessageStatus.values,
          data['status'],
          MessageStatus.sent,
        ),
      );

  FirestoreMap toFirestore() => {
    'text': text,
    'sentAt': writeDate(sentAt),
    'senderId': senderId,
    'status': status.name,
  };
}
