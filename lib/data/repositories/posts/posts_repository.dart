// Feed posts and likes.
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import 'post_comment.dart';

abstract interface class PostsRepository {
  // Newest first. The Home screen moves pinned posts to the top.
  Future<List<PostModel>> fetchFeed();

  Future<List<PostModel>> fetchPostsByAuthor(String authorId);

  Future<String> createPost(PostModel post);

  // Only the author may delete a post (enforced in firestore.rules).
  Future<void> deletePost(String postId);

  Future<List<PostComment>> fetchComments(String postId);

  Future<void> addComment({
    required String postId,
    required UserModel author,
    required String text,
  });

  Future<Set<String>> fetchLikedPostIds(String userId);

  Future<Set<String>> fetchRsvpedPostIds(String userId);

  // Posts the user bookmarked with the save button.
  Future<Set<String>> fetchSavedPostIds(String userId);

  Future<Map<String, String>> fetchPollVotes(String userId);

  Future<void> setPollVote({
    required String userId,
    required String postId,
    required String option,
  });

  // Also moves the post's likeCount up or down by one.
  Future<void> setLiked({
    required String userId,
    required String postId,
    required bool liked,
  });

  Future<void> setRsvp({
    required String userId,
    required String postId,
    required bool rsvped,
  });

  Future<void> setSaved({
    required String userId,
    required String postId,
    required bool saved,
  });
}
