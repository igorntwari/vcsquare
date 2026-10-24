// Placeholder feed posts for building screens before real data.
import '../models/event_model.dart';
import '../models/post_model.dart';
import 'dummy_users.dart';

DateTime _ago({int days = 0, int hours = 0, int minutes = 0}) => DateTime.now()
    .subtract(Duration(days: days, hours: hours, minutes: minutes));

final List<PostModel> dummyPosts = [
  PostModel(
    id: 'p01',
    author: aluRegistry,
    createdAt: _ago(hours: 2),
    isPinned: true,
    isMandatoryRead: true,
    topic: 'Term 1 Briefing',
    title: 'Important Academic Milestone:',
    body:
        'Term 1 course registration is officially unlocked for all '
        'undergraduate leadership scholars. All learners must complete their '
        'track selections by Friday, 23:59 CAT.',
    likeCount: 184,
    commentCount: 29,
    event: EventModel(
      title: 'Masterclass Keynote',
      venue: 'Kigali Hall A',
      startsAt: DateTime(2026, 11, 18, 14),
      note: 'Seats capped',
      showAsBanner: false,
    ),
  ),
  PostModel(
    id: 'p02',
    author: amaraKamau,
    createdAt: _ago(minutes: 45),
    audience: 'Everyone',
    body:
        'Our prototype solar hydroponics pod on the innovation deck just '
        'logged its first full week of zero-grid telemetry! Huge props to the '
        'Agri-Ventures pod for late-night sensor calibration. Africa feeds '
        'itself when we build sustainably. 🌱💡',
    imagePath: 'assets/images/posts/solar_pod.jpg',
    imageCaption: 'Kigali Innovation Deck',
    likeCount: 42,
    commentCount: 8,
    commentPreview: const CommentPreview(
      author: kofiMensah,
      text: 'Can we schedule a site tour for the Venture Design squad on '
          'Thursday?',
    ),
  ),
  PostModel(
    id: 'p03',
    author: roboticsClub,
    createdAt: _ago(hours: 3),
    body:
        "The hardware is primed! Join us for the semester's largest student "
        'showcase featuring autonomous ground rovers, drone mapping for '
        'conservation, and edge computer vision demos.',
    likeCount: 67,
    commentCount: 14,
    event: EventModel(
      label: 'ANNUAL SHOWCASE',
      title: 'ALU AI & Hardware Demo Day',
      venue: 'Auditorium North',
      startsAt: DateTime(2026, 10, 31, 16, 30),
    ),
  ),
  PostModel(
    id: 'p04',
    author: aluStudentLife,
    createdAt: _ago(hours: 5),
    isMandatoryRead: true,
    title: 'Residence check-in:',
    body:
        'Check-in for the new hostel blocks closes this Sunday. Bring your '
        'student ID and signed housing agreement to the Student Life desk.',
    likeCount: 96,
    commentCount: 12,
  ),
  PostModel(
    id: 'p05',
    author: kofiMensah,
    createdAt: _ago(hours: 6),
    audience: 'Everyone',
    body:
        "Anyone up for a late-night study session on Data Structures before "
        "Thursday's quiz? Library Foyer, 8pm. Bring snacks 🍪",
    likeCount: 23,
    commentCount: 11,
    isLiked: true,
  ),
  PostModel(
    id: 'p06',
    author: afroDanceSociety,
    createdAt: _ago(hours: 8),
    body:
        'Our end-of-term showcase is here! Expect amapiano, azonto and a '
        'surprise guest choreographer. Tickets at the door or from any '
        'committee member.',
    likeCount: 118,
    commentCount: 20,
    event: EventModel(
      label: 'END OF TERM SHOWCASE',
      title: 'Afro Beats Night',
      venue: 'Main Courtyard',
      startsAt: DateTime(2026, 11, 7, 19),
      priceRwf: 3000,
    ),
  ),
  PostModel(
    id: 'p07',
    author: aminaToure,
    createdAt: _ago(hours: 10),
    audience: 'Everyone',
    body:
        'Throwback to the Pan-African Leadership Summit last week. Still '
        'processing everything we learned about building institutions that '
        'outlast us.',
    imagePath: 'assets/images/posts/leadership_summit.jpg',
    imageCaption: 'Leadership Summit',
    likeCount: 54,
    commentCount: 6,
  ),
  PostModel(
    id: 'p08',
    author: googleDevClub,
    createdAt: _ago(hours: 12),
    body:
        'Registrations are open! 24 hours, teams of four, real problems from '
        'local startups. Mentors from Google and Andela will be on site.',
    likeCount: 201,
    commentCount: 33,
    event: EventModel(
      label: 'HACKATHON',
      title: 'Build for Africa Hackathon',
      venue: 'Innovation Lab Hub 2',
      startsAt: DateTime(2026, 11, 14, 9),
    ),
  ),
  PostModel(
    id: 'p09',
    author: aluCareers,
    createdAt: _ago(days: 1),
    body:
        'Summer internship applications for partner companies across Kigali, '
        'Nairobi and Lagos are now live on the careers portal. Deadline: '
        '15 November.',
    likeCount: 143,
    commentCount: 17,
  ),
  PostModel(
    id: 'p10',
    author: kwameOsei,
    createdAt: _ago(days: 1, hours: 2),
    audience: 'Everyone',
    body:
        'Selling my old graphing calculator in the Market tab. Perfect for '
        'first-years taking Quant Methods. DM me!',
    likeCount: 8,
    commentCount: 3,
  ),
  PostModel(
    id: 'p11',
    author: entrepreneurshipHub,
    createdAt: _ago(days: 1, hours: 5),
    body:
        'Ten student startups. Five minutes each. One investor panel. Come '
        'cheer on your classmates!',
    likeCount: 76,
    commentCount: 9,
    event: EventModel(
      label: 'PITCH NIGHT',
      title: 'Founders Pitch Night',
      venue: 'Innovation Hub Atrium',
      startsAt: DateTime(2026, 11, 20, 18),
      priceRwf: 5000,
    ),
  ),
  PostModel(
    id: 'p12',
    author: jeanLucNiyonzima,
    createdAt: _ago(days: 2),
    audience: 'Everyone',
    body:
        'Inter-cohort football final this Saturday! Class of 2025 vs Class of '
        '2027. Bring the noise ⚽️',
    imagePath: 'assets/images/posts/football_final.jpg',
    imageCaption: 'Campus Pitch',
    likeCount: 88,
    commentCount: 21,
  ),
  PostModel(
    id: 'p13',
    author: aluRegistry,
    createdAt: _ago(days: 2, hours: 3),
    isMandatoryRead: true,
    title: 'Mid-term timetables published:',
    body:
        'Please check your student portal and report any clashes to the '
        'Registry before Wednesday.',
    likeCount: 210,
    commentCount: 41,
  ),
  PostModel(
    id: 'p14',
    author: zainabKamara,
    createdAt: _ago(days: 2, hours: 6),
    audience: 'Everyone',
    body:
        'Just finished my first Flutter app for the ALU Ventures challenge 🚀 '
        'It tracks water usage in student hostels. Feedback welcome!',
    likeCount: 64,
    commentCount: 15,
    commentPreview: const CommentPreview(
      author: chidiOkafor,
      text: 'This is awesome. Would love to help with the backend!',
    ),
  ),
  PostModel(
    id: 'p15',
    author: debateUnion,
    createdAt: _ago(days: 3),
    body:
        'Pick a side, sharpen your arguments and join our open-floor debate. '
        'First-timers very welcome.',
    likeCount: 39,
    commentCount: 7,
    event: EventModel(
      label: 'OPEN DEBATE',
      title: 'Should AI Grade Our Essays?',
      venue: 'Lecture Hall 3',
      startsAt: DateTime(2026, 11, 12, 17),
    ),
  ),
  PostModel(
    id: 'p16',
    author: chidiOkafor,
    createdAt: _ago(days: 3, hours: 4),
    audience: 'Everyone',
    body:
        'Shoutout to the cafeteria team for the new jollof Fridays. Absolute '
        'game changer 🍛',
    likeCount: 132,
    commentCount: 26,
    isLiked: true,
  ),
  PostModel(
    id: 'p17',
    author: aluStudentLife,
    createdAt: _ago(days: 4),
    body:
        'Wellness Week starts Monday: free yoga sessions, counselling '
        'drop-ins and a mental health panel. Look after yourselves, leaders.',
    likeCount: 77,
    commentCount: 5,
  ),
  PostModel(
    id: 'p18',
    author: fatimaDiallo,
    createdAt: _ago(days: 4, hours: 7),
    audience: 'Everyone',
    body:
        'Our design sprint team just wrapped up user interviews for the '
        'campus shuttle app. So many insights!',
    imagePath: 'assets/images/posts/design_sprint.jpg',
    imageCaption: 'Design Studio',
    likeCount: 45,
    commentCount: 4,
  ),
  PostModel(
    id: 'p19',
    author: roboticsClub,
    createdAt: _ago(days: 5),
    body:
        'Drone mapping workshop recap: we flew over the campus wetland and '
        'built our first orthomosaic map. Slides are up in the club room.',
    likeCount: 51,
    commentCount: 6,
  ),
  PostModel(
    id: 'p20',
    author: googleDevClub,
    createdAt: _ago(days: 6),
    body:
        'Hands-on session: auth, Firestore and hosting in two hours. Laptops '
        'required.',
    likeCount: 58,
    commentCount: 10,
    event: EventModel(
      label: 'WORKSHOP',
      title: 'Intro to Firebase',
      venue: 'Innovation Lab Hub 2',
      startsAt: DateTime(2026, 11, 3, 15),
      priceRwf: 1000,
    ),
  ),
];
