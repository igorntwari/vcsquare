// Model representing a student suggested in "People You May Know".
import 'firestore_helpers.dart';
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

  // users/{currentUserId}/peerSuggestions/{user.id}.
  factory PeerSuggestionModel.fromFirestore(
    FirestoreMap data, {
    required UserModel user,
  }) => PeerSuggestionModel(
    user: user,
    program: readString(data['program']),
    focus: readString(data['focus']),
    mutualCount: readInt(data['mutualCount']),
    sharedInterest: readString(data['sharedInterest']),
  );

  FirestoreMap toFirestore() => {
    'program': program,
    'focus': focus,
    'mutualCount': mutualCount,
    'sharedInterest': sharedInterest,
  };
}
