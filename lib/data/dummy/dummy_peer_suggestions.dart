// Placeholder "People You May Know" suggestions before real data.
import '../models/peer_suggestion_model.dart';
import 'dummy_users.dart';

const List<PeerSuggestionModel> dummyPeerSuggestions = [
  PeerSuggestionModel(
    user: kofiMensah,
    program: "BSc CS '26",
    focus: 'Software Engineering • Kigali Campus',
    mutualCount: 14,
    sharedInterest: 'FinTech',
  ),
  PeerSuggestionModel(
    user: aminaWanjiku,
    program: 'Global Challenges',
    focus: 'Agri-tech • Climate Resilience',
    mutualCount: 8,
    sharedInterest: 'Social Impact',
  ),
  PeerSuggestionModel(
    user: tendaiMoyo,
    program: "BSc EB '27",
    focus: 'Entrepreneurial Leadership • Kigali Campus',
    mutualCount: 5,
    sharedInterest: 'Startups',
  ),
];
