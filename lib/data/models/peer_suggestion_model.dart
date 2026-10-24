// Model representing a student suggested in "People You May Know".
import 'user_model.dart';

class PeerSuggestionModel {
  const PeerSuggestionModel({
    required this.user,
    required this.program,
    required this.focus,
    required this.mutualCount,
    required this.sharedInterest,
  });

  final UserModel user;

  // Short programme tag, e.g. "BSc CS '26".
  final String program;

  // Study track and campus, e.g. "Software Engineering • Kigali Campus".
  final String focus;
  final int mutualCount;

  // Common interest, e.g. "FinTech".
  final String sharedInterest;
}
