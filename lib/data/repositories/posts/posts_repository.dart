// Feed posts and likes.
import '../../models/post_model.dart';

abstract interface class PostsRepository {
  // Newest first. The Home screen moves pinned posts to the top.
  Future<List<PostModel>> fetchFeed();

  Future<List<PostModel>> fetchPostsByAuthor(String authorId);

  Future<Set<String>> fetchLikedPostIds(String userId);

  // Also moves the post's likeCount up or down by one.
  Future<void> setLiked({
    required String userId,
    required String postId,
    required bool liked,
  });
}
