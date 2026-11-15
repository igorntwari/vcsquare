// Model representing a community feed post.
import 'event_model.dart';
import 'firestore_helpers.dart';
import 'user_model.dart';

class PostModel {
  const PostModel({
    required this.id,
    required this.author,
    required this.createdAt,
    required this.body,
    this.title,
    this.topic,
    this.audience,
    this.imagePath,
    this.imageCaption,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isPinned = false,
    this.isMandatoryRead = false,
    this.event,
    this.commentPreview,
  });

  final String id;
  final UserModel author;
  final DateTime createdAt;
  final String body;

  // Bold lead-in before the body, e.g. "Important Academic Milestone:".
  final String? title;

  // Small tag on pinned posts, e.g. "Term 1 Briefing".
  final String? topic;

  // Who can see the post, e.g. "Everyone".
  final String? audience;
  final String? imagePath;

  // Location pill over the photo, e.g. "Kigali Innovation Deck".
  final String? imageCaption;

  // Includes the current user's like, if any. Whether the current user liked
  // it comes from PostsRepository.fetchLikedPostIds.
  final int likeCount;
  final int commentCount;
  final bool isPinned;
  final bool isMandatoryRead;
  final EventModel? event;
  final CommentPreview? commentPreview;

  // posts/{id}. [author] and the comment author are looked up from
  // authorId and commentPreview.authorId.
  factory PostModel.fromFirestore(
    String id,
    FirestoreMap data, {
    required UserModel author,
    UserModel? commentAuthor,
  }) {
    final event = readMap(data['event']);
    final comment = readMap(data['commentPreview']);
    return PostModel(
      id: id,
      author: author,
      createdAt: readDate(data['createdAt']),
      body: readString(data['body']),
      title: data['title'] as String?,
      topic: data['topic'] as String?,
      audience: data['audience'] as String?,
      imagePath: data['imagePath'] as String?,
      imageCaption: data['imageCaption'] as String?,
      likeCount: readInt(data['likeCount']),
      commentCount: readInt(data['commentCount']),
      isPinned: data['isPinned'] as bool? ?? false,
      isMandatoryRead: data['isMandatoryRead'] as bool? ?? false,
      event: event == null ? null : EventModel.fromFirestore(event),
      commentPreview: comment == null || commentAuthor == null
          ? null
          : CommentPreview(
              author: commentAuthor,
              text: readString(comment['text']),
            ),
    );
  }

  FirestoreMap toFirestore() => {
    'authorId': author.id,
    'createdAt': writeDate(createdAt),
    'body': body,
    'title': title,
    'topic': topic,
    'audience': audience,
    'imagePath': imagePath,
    'imageCaption': imageCaption,
    'likeCount': likeCount,
    'commentCount': commentCount,
    'isPinned': isPinned,
    'isMandatoryRead': isMandatoryRead,
    'event': event?.toFirestore(),
    'commentPreview': commentPreview?.toFirestore(),
  };
}

// Latest comment shown under a post.
class CommentPreview {
  const CommentPreview({required this.author, required this.text});

  final UserModel author;
  final String text;

  FirestoreMap toFirestore() => {'authorId': author.id, 'text': text};
}
