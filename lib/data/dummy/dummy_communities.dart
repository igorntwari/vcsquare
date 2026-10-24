// Placeholder communities for building screens before real data.
// Cover photos are from Unsplash (free to use under the Unsplash License).
import '../models/community_model.dart';
import 'dummy_users.dart';

const List<CommunityModel> dummyCommunities = [
  CommunityModel(
    id: 'cm_software',
    name: 'ALU Software Engineers',
    tag: 'Tech',
    description:
        'Open source hackathons, web3 sprints, and mock technical interviews.',
    memberCount: 340,
    activity: 'Next meetup: Friday 18:00',
    members: [kofiMensah, zainabKamara, chidiOkafor],
    imagePath: 'assets/images/communities/software_engineers.jpg',
  ),
  CommunityModel(
    id: 'cm_debate',
    name: 'Pan-African Debate Society',
    tag: 'Policy',
    description:
        'Sharpening persuasive diplomacy, governance debate, and '
        'parliamentary rhetoric.',
    memberCount: 180,
    activity: 'Model AU Delegation open',
    members: [aminaToure, jeanLucNiyonzima, fatimaDiallo],
    imagePath: 'assets/images/communities/debate_society.jpg',
  ),
  CommunityModel(
    id: 'cm_culture',
    name: 'Rwandan Cultural Troupe',
    tag: 'Culture',
    description:
        'Preserving heritage through traditional Intore dance, drumming, '
        'and folklore.',
    memberCount: 115,
    activity: 'Rehearsing for Cultural Gala',
    members: [kwameOsei, aminaWanjiku, tendaiMoyo],
    imagePath: 'assets/images/communities/cultural_troupe.jpg',
  ),
];
