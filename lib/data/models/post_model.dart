// Model representing a community feed post.
import 'event_model.dart';
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
    this.isLiked = false,
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
  final int likeCount;
  final int commentCount;

  // Whether the current user had already liked it when the feed loaded.
  final bool isLiked;
  final bool isPinned;
  final bool isMandatoryRead;
  final EventModel? event;
  final CommentPreview? commentPreview;
}

// Latest comment shown under a post.
class CommentPreview {
  const CommentPreview({required this.author, required this.text});

  final UserModel author;
  final String text;
}
