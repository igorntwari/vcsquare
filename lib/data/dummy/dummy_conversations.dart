// Placeholder conversations for building screens before real data.
import '../models/conversation_model.dart';
import 'dummy_listings.dart';
import 'dummy_messages.dart';
import 'dummy_users.dart';

final List<ConversationModel> dummyConversations = [
  ConversationModel(
    id: 'cv_macbook',
    participant: kwameOsei,
    type: ConversationType.marketplace,
    listing: dummyListings.firstWhere((listing) => listing.id == 'l01'),
    unreadCount: 2,
    messages: dummyMessages['cv_macbook']!,
  ),
  ConversationModel(
    id: 'cv_student_life',
    participant: aluStudentLife,
    type: ConversationType.official,
    subject: 'Club Budget Allocation Approved 🎯',
    messages: dummyMessages['cv_student_life']!,
  ),
  ConversationModel(
    id: 'cv_kofi',
    participant: kofiMensah,
    type: ConversationType.peer,
    subject: 'DS Study Session',
    unreadCount: 2,
    messages: dummyMessages['cv_kofi']!,
  ),
  ConversationModel(
    id: 'cv_zainab',
    participant: zainabKamara,
    type: ConversationType.peer,
    subject: 'Study Group • System Design',
    messages: dummyMessages['cv_zainab']!,
  ),
  ConversationModel(
    id: 'cv_chair',
    participant: jeanLucNiyonzima,
    type: ConversationType.marketplace,
    listing: dummyListings.firstWhere((listing) => listing.id == 'l03'),
    messages: dummyMessages['cv_chair']!,
  ),
  ConversationModel(
    id: 'cv_robotics',
    participant: roboticsClub,
    type: ConversationType.official,
    subject: 'Demo Day Sign-ups',
    unreadCount: 1,
    messages: dummyMessages['cv_robotics']!,
  ),
  ConversationModel(
    id: 'cv_jacket',
    participant: aminaToure,
    type: ConversationType.marketplace,
    listing: dummyListings.firstWhere((listing) => listing.id == 'l02'),
    messages: dummyMessages['cv_jacket']!,
  ),
];

// Conversations with unread messages, shown on the Messages tab badge.
int get dummyUnreadConversationCount => dummyConversations
    .where((conversation) => conversation.unreadCount > 0)
    .length;
