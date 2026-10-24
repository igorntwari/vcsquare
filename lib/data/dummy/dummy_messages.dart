// Placeholder chat messages for building screens before real data.
import '../models/message_model.dart';

DateTime _ago({int days = 0, int hours = 0, int minutes = 0}) => DateTime.now()
    .subtract(Duration(days: days, hours: hours, minutes: minutes));

// Messages per conversation id, oldest first.
final Map<String, List<MessageModel>> dummyMessages = {
  'cv_macbook': [
    MessageModel(
      id: 'm01',
      text: 'Hi Kwame! Saw your MacBook Air listing 👀',
      sentAt: _ago(minutes: 32),
      isMine: true,
    ),
    MessageModel(
      id: 'm02',
      text: 'Hey Amara! Yes, it is in great shape. Battery health is 92%.',
      sentAt: _ago(minutes: 20),
      isMine: false,
    ),
    MessageModel(
      id: 'm03',
      text: 'Does it come with the original charger?',
      sentAt: _ago(minutes: 15),
      isMine: true,
    ),
    MessageModel(
      id: 'm04',
      text: 'Yep, charger and box both included.',
      sentAt: _ago(minutes: 6),
      isMine: false,
    ),
    MessageModel(
      id: 'm05',
      text: 'Is this still available for campus pickup today?',
      sentAt: _ago(minutes: 4),
      isMine: false,
    ),
  ],
  'cv_student_life': [
    MessageModel(
      id: 'm06',
      text: 'Hello! Submitting the Robotics Club budget request for Term 1.',
      sentAt: _ago(days: 1, hours: 3),
      isMine: true,
    ),
    MessageModel(
      id: 'm07',
      text:
          'Hi team! The Pan-African Robotics Club budget has been approved. '
          'Funds will be released on Monday.',
      sentAt: _ago(hours: 2),
      isMine: false,
    ),
    MessageModel(
      id: 'm08',
      text: 'Amazing, thank you so much! 🎉',
      sentAt: _ago(hours: 1, minutes: 40),
      isMine: true,
    ),
  ],
  'cv_zainab': [
    MessageModel(
      id: 'm09',
      text: 'Can you check my diagram before the study group?',
      sentAt: _ago(hours: 5),
      isMine: false,
    ),
    MessageModel(
      id: 'm10',
      text: 'Reviewed the system design diagram, looks solid! Left 2 notes.',
      sentAt: _ago(hours: 3),
      isMine: true,
    ),
  ],
  'cv_chair': [
    MessageModel(
      id: 'm11',
      text: 'Hi Jean-Luc, is the lounge chair still for sale?',
      sentAt: _ago(days: 1, hours: 6),
      isMine: true,
    ),
    MessageModel(
      id: 'm12',
      text: 'It is! Happy to do 55,000 if you pick it up this week.',
      sentAt: _ago(days: 1, hours: 4),
      isMine: false,
    ),
    MessageModel(
      id: 'm13',
      text: 'I can meet you by 4 PM right outside the library.',
      sentAt: _ago(days: 1, hours: 2),
      isMine: true,
      status: MessageStatus.sent,
    ),
  ],
  'cv_kofi': [
    MessageModel(
      id: 'm14',
      text: 'Are you joining the late-night DS session tomorrow?',
      sentAt: _ago(minutes: 50),
      isMine: false,
    ),
    MessageModel(
      id: 'm15',
      text: 'Bring snacks if you are coming 🍪',
      sentAt: _ago(minutes: 48),
      isMine: false,
    ),
  ],
  'cv_robotics': [
    MessageModel(
      id: 'm16',
      text: 'Welcome to the Robotics & AI Club! Demo Day sign-ups are open.',
      sentAt: _ago(days: 2),
      isMine: false,
    ),
  ],
  'cv_jacket': [
    MessageModel(
      id: 'm17',
      text: 'Hey! Would you take 35,000 for the leather jacket?',
      sentAt: _ago(days: 3),
      isMine: true,
    ),
    MessageModel(
      id: 'm18',
      text: 'Deal! Meet at the Innovation Hub Atrium?',
      sentAt: _ago(days: 3),
      isMine: false,
    ),
  ],
};
