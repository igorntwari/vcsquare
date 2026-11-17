// Sample-data posts. Likes are kept in memory until the app restarts.
import '../../dummy/dummy_posts.dart';
import '../../dummy/dummy_viewer_state.dart';
import '../../models/post_model.dart';
import 'posts_repository.dart';

class SamplePostsRepository implements PostsRepository {
  final Set<String> _likedPostIds = {...dummyLikedPostIds};
  final List<PostModel> _createdPosts = [];

  @override
  Future<List<PostModel>> fetchFeed() async => [
    ..._createdPosts.reversed,
    ...dummyPosts,
  ];

  @override
  Future<List<PostModel>> fetchPostsByAuthor(String authorId) async => [
    ..._createdPosts,
    ...dummyPosts,
  ].where((post) => post.author.id == authorId).toList();

  @override
  Future<String> createPost(PostModel post) async {
    final id = 'sample-${DateTime.now().microsecondsSinceEpoch}';
    _createdPosts.add(
      PostModel(
        id: id,
        author: post.author,
        createdAt: post.createdAt,
        body: post.body,
        title: post.title,
        topic: post.topic,
        audience: post.audience,
        imagePath: post.imagePath,
        imageCaption: post.imageCaption,
        likeCount: post.likeCount,
        commentCount: post.commentCount,
        isPinned: post.isPinned,
        isMandatoryRead: post.isMandatoryRead,
        event: post.event,
        commentPreview: post.commentPreview,
      ),
    );
    return id;
  }

  @override
  Future<Set<String>> fetchLikedPostIds(String userId) async => {
    ..._likedPostIds,
  };

  @override
  Future<void> setLiked({
    required String userId,
    required String postId,
    required bool liked,
  }) async {
    liked ? _likedPostIds.add(postId) : _likedPostIds.remove(postId);
  }
}
