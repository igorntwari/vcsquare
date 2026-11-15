// Model representing a chat conversation summary.
import 'firestore_helpers.dart';
import 'listing_model.dart';
import 'message_model.dart';
import 'user_model.dart';

enum ConversationType { marketplace, official, peer }

// The inbox row. The full message history is loaded separately through
// ChatsRepository.watchMessages.
class ConversationModel {
  const ConversationModel({
    required this.id,
    required this.participant,
    required this.type,
    required this.lastMessage,
    this.subject,
    this.listing,
    this.unreadCount = 0,
  });

  final String id;

  // The other person, office or club in the chat.
  final UserModel participant;
  final ConversationType type;
  final MessageModel lastMessage;

  // Bold topic line, e.g. "Club Budget Allocation Approved 🎯".
  final String? subject;

  // Marketplace item the chat is about.
  final ListingModel? listing;

  // Unread messages for the signed-in user.
  final int unreadCount;

  // conversations/{id}, read from [currentUserId]'s point of view.
  // [participant] and [listing] are looked up from participantIds and
  // listingId.
  factory ConversationModel.fromFirestore(
    String id,
    FirestoreMap data, {
    required String currentUserId,
    required UserModel participant,
    ListingModel? listing,
  }) {
    final unread = readMap(data['unreadCounts']) ?? const {};
    return ConversationModel(
      id: id,
      participant: participant,
      type: readEnum(
        ConversationType.values,
        data['type'],
        ConversationType.peer,
      ),
      lastMessage: MessageModel.fromFirestore(
        'last',
        readMap(data['lastMessage']) ?? const {},
      ),
      subject: data['subject'] as String?,
      listing: listing,
      unreadCount: readInt(unread[currentUserId]),
    );
  }

  // The other participant's id, given the stored participantIds.
  static String otherParticipantId(FirestoreMap data, String currentUserId) {
    final ids = readStringList(data['participantIds']);
    return ids.firstWhere((id) => id != currentUserId, orElse: () => '');
  }

  FirestoreMap toFirestore({required String currentUserId}) => {
    'participantIds': [currentUserId, participant.id],
    'type': type.name,
    'subject': subject,
    'listingId': listing?.id,
    'lastMessage': lastMessage.toFirestore(),
    'updatedAt': writeDate(lastMessage.sentAt),
    'unreadCounts': {currentUserId: unreadCount, participant.id: 0},
  };
}
