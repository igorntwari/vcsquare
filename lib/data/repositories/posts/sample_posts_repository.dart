// Sample-data posts. Likes are kept in memory until the app restarts.
import '../../dummy/dummy_posts.dart';
import '../../dummy/dummy_viewer_state.dart';
import '../../models/post_model.dart';
import 'posts_repository.dart';

class SamplePostsRepository implements PostsRepository {
  final Set<String> _likedPostIds = {...dummyLikedPostIds};

  @override
  Future<List<PostModel>> fetchFeed() async => List.of(dummyPosts);

  @override
  Future<List<PostModel>> fetchPostsByAuthor(String authorId) async =>
      dummyPosts.where((post) => post.author.id == authorId).toList();

  @override
  Future<Set<String>> fetchLikedPostIds(String userId) async =>
      {..._likedPostIds};

  @override
  Future<void> setLiked({
    required String userId,
    required String postId,
    required bool liked,
  }) async {
    liked ? _likedPostIds.add(postId) : _likedPostIds.remove(postId);
  }
}
