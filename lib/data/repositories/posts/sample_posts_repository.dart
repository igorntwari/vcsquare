// Sample-data posts. Likes are kept in memory until the app restarts.
import 'dart:async';

import '../../dummy/dummy_posts.dart';
import '../../dummy/dummy_viewer_state.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import 'post_comment.dart';
import 'posts_repository.dart';

class SamplePostsRepository implements PostsRepository {
  final Set<String> _likedPostIds = {...dummyLikedPostIds};
  final Set<String> _rsvpedPostIds = {};
  final Set<String> _savedPostIds = {};
  final List<PostModel> _createdPosts = [];
  final Set<String> _deletedPostIds = {};
  final Map<String, List<PostComment>> _comments = {};
  final Map<String, Map<String, String>> _pollVotes = {};
  final Map<String, StreamController<PostEngagementCounts>> _postCountStreams =
      {};
  final Map<String, int> _likeAdjustments = {};

  @override
  Future<List<PostModel>> fetchFeed() async => [
    ..._createdPosts.reversed,
    ...dummyPosts,
  ].where(_isKept).map(_withComments).toList();

  @override
  Future<List<PostModel>> fetchPostsByAuthor(String authorId) async => [
    ..._createdPosts,
    ...dummyPosts,
  ]
      .where((post) => _isKept(post) && post.author.id == authorId)
      .map(_withComments)
      .toList();

  bool _isKept(PostModel post) => !_deletedPostIds.contains(post.id);

  @override
  Future<void> deletePost(String postId) async {
    _deletedPostIds.add(postId);
    _createdPosts.removeWhere((post) => post.id == postId);
  }

  @override
  Future<void> updatePost(PostModel post) async {
    final index = _createdPosts.indexWhere((item) => item.id == post.id);
    if (index >= 0) _createdPosts[index] = post;
  }

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
        poll: post.poll,
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
    _postCountStreams[postId]?.add(_postCounts(postId));
  }

  @override
  Stream<PostEngagementCounts> watchPostCounts(String postId) =>
      Stream<PostEngagementCounts>.multi((controller) {
        controller.add(_postCounts(postId));
        controller.addStream(
          _postCountStreams
              .putIfAbsent(
                postId,
                () => StreamController<PostEngagementCounts>.broadcast(),
              )
              .stream,
        );
      });

  PostEngagementCounts _postCounts(String postId) {
    PostModel? post;
    for (final candidate in [..._createdPosts, ...dummyPosts]) {
      if (candidate.id == postId) {
        post = candidate;
        break;
      }
    }
    if (post == null) {
      return const PostEngagementCounts(likeCount: 0, commentCount: 0);
    }
    return PostEngagementCounts(
      likeCount: post.likeCount + (_likeAdjustments[postId] ?? 0),
      commentCount: _withComments(post).commentCount,
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
      poll: post.poll,
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
  Future<Set<String>> fetchSavedPostIds(String userId) async => {
    ..._savedPostIds,
  };

  @override
  Future<void> setSaved({
    required String userId,
    required String postId,
    required bool saved,
  }) async {
    saved ? _savedPostIds.add(postId) : _savedPostIds.remove(postId);
  }

  @override
  Future<Map<String, String>> fetchPollVotes(String userId) async =>
      {...?_pollVotes[userId]};

  @override
  Future<void> setPollVote({
    required String userId,
    required String postId,
    required String option,
  }) async {
    _pollVotes.putIfAbsent(userId, () => {})[postId] = option;
  }

  @override
  Future<void> setLiked({
    required String userId,
    required String postId,
    required bool liked,
  }) async {
    final wasLiked = _likedPostIds.contains(postId);
    if (wasLiked == liked) return;
    liked ? _likedPostIds.add(postId) : _likedPostIds.remove(postId);
    _likeAdjustments.update(
      postId,
      (count) => count + (liked ? 1 : -1),
      ifAbsent: () => liked ? 1 : -1,
    );
    _postCountStreams[postId]?.add(_postCounts(postId));
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
