// Model representing a chat conversation summary.
import 'listing_model.dart';
import 'message_model.dart';
import 'user_model.dart';

enum ConversationType { marketplace, official, peer }

class ConversationModel {
  const ConversationModel({
    required this.id,
    required this.participant,
    required this.type,
    required this.messages,
    this.subject,
    this.listing,
    this.unreadCount = 0,
  });

  final String id;

  // The other person, office or club in the chat.
  final UserModel participant;
  final ConversationType type;

  // Oldest first.
  final List<MessageModel> messages;

  // Bold topic line, e.g. "Club Budget Allocation Approved 🎯".
  final String? subject;

  // Marketplace item the chat is about.
  final ListingModel? listing;
  final int unreadCount;

  MessageModel get lastMessage => messages.last;
}
