// Comment data used by the Home posts repository.
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/firestore_helpers.dart';
import '../../models/user_model.dart';

class PostComment {
  const PostComment({
    required this.id,
    required this.author,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final UserModel author;
  final String text;
  final DateTime createdAt;

  factory PostComment.fromFirestore(
    String id,
    FirestoreMap data, {
    required UserModel author,
  }) => PostComment(
    id: id,
    author: author,
    text: readString(data['text']),
    createdAt: readDate(data['createdAt']),
  );

  FirestoreMap toFirestore() => {
    'authorId': author.id,
    'text': text,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}
