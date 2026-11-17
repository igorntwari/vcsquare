// Sample-data posts. Likes are kept in memory until the app restarts.
import '../../dummy/dummy_posts.dart';
import '../../dummy/dummy_viewer_state.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import 'post_comment.dart';
import 'posts_repository.dart';

class SamplePostsRepository implements PostsRepository {
  final Set<String> _likedPostIds = {...dummyLikedPostIds};
  final Set<String> _rsvpedPostIds = {};
  final List<PostModel> _createdPosts = [];
  final Map<String, List<PostComment>> _comments = {};

  @override
  Future<List<PostModel>> fetchFeed() async =>
      [..._createdPosts.reversed, ...dummyPosts].map(_withComments).toList();

  @override
  Future<List<PostModel>> fetchPostsByAuthor(String authorId) async => [
    ..._createdPosts,
    ...dummyPosts,
  ].where((post) => post.author.id == authorId).map(_withComments).toList();

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
  Future<List<PostComment>> fetchComments(String postId) async =>
      List.unmodifiable(_comments[postId] ?? const []);

  @override
  Future<void> addComment({
    required String postId,
    required UserModel author,
    required String text,
  }) async {
    final comments = _comments.putIfAbsent(postId, () => []);
    comments.add(
      PostComment(
        id: 'sample-${DateTime.now().microsecondsSinceEpoch}',
        author: author,
        text: text,
        createdAt: DateTime.now(),
      ),
    );
  }

  PostModel _withComments(PostModel post) {
    final comments = _comments[post.id];
    if (comments == null || comments.isEmpty) return post;
    final latest = comments.last;
    return PostModel(
      id: post.id,
      author: post.author,
      createdAt: post.createdAt,
      body: post.body,
      title: post.title,
      topic: post.topic,
      audience: post.audience,
      imagePath: post.imagePath,
      imageCaption: post.imageCaption,
      likeCount: post.likeCount,
      commentCount: post.commentCount + comments.length,
      isPinned: post.isPinned,
      isMandatoryRead: post.isMandatoryRead,
      event: post.event,
      commentPreview: CommentPreview(author: latest.author, text: latest.text),
    );
  }

  @override
  Future<Set<String>> fetchLikedPostIds(String userId) async => {
    ..._likedPostIds,
  };

  @override
  Future<Set<String>> fetchRsvpedPostIds(String userId) async => {
    ..._rsvpedPostIds,
  };

  @override
  Future<void> setLiked({
    required String userId,
    required String postId,
    required bool liked,
  }) async {
    liked ? _likedPostIds.add(postId) : _likedPostIds.remove(postId);
  }

  @override
  Future<void> setRsvp({
    required String userId,
    required String postId,
    required bool rsvped,
  }) async {
    rsvped ? _rsvpedPostIds.add(postId) : _rsvpedPostIds.remove(postId);
  }
}
