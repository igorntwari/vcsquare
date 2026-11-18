// A lightweight campus poll attached to a post.
import 'firestore_helpers.dart';

class PostPoll {
  const PostPoll({required this.question, required this.options});

  final String question;
  final List<String> options;

  factory PostPoll.fromFirestore(FirestoreMap data) => PostPoll(
    question: readString(data['question']),
    options: (data['options'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .toList(growable: false),
  );

  FirestoreMap toFirestore() => {'question': question, 'options': options};
}
