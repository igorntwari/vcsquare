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
  final List<PostModel> _createdPosts = [];
  final Map<String, List<PostComment>> _comments = {};
  final Map<String, Map<String, String>> _pollVotes = {};
  final Map<String, StreamController<Map<String, int>>> _pollCountStreams = {};
  final Map<String, StreamController<PostEngagementCounts>> _postCountStreams =
      {};
  final Map<String, int> _likeAdjustments = {};

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
        poll: post.poll,
        pollCounts: post.pollCounts,
        pollTotal: post.pollTotal,
      ),
    );
    return id;
  }

  @override
  Future<void> updatePost(PostModel post) async {
    final index = _createdPosts.indexWhere((item) => item.id == post.id);
    if (index >= 0) _createdPosts[index] = post;
  }

  @override
  Future<void> deletePost(String postId) async {
    _createdPosts.removeWhere((post) => post.id == postId);
    _comments.remove(postId);
    for (final votes in _pollVotes.values) {
      votes.remove(postId);
    }
    _likedPostIds.remove(postId);
    _rsvpedPostIds.remove(postId);
  }

  @override
  Stream<Map<String, int>> watchPollCounts(String postId) =>
      Stream<Map<String, int>>.multi((controller) {
        controller.add(_pollCounts(postId));
        controller.addStream(
          _pollCountStreams
              .putIfAbsent(
                postId,
                () => StreamController<Map<String, int>>.broadcast(),
              )
              .stream,
        );
      });

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
      pollCounts: post.pollCounts,
      pollTotal: post.pollTotal,
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
  Future<Map<String, String>> fetchPollVotes(String userId) async => {
    ...?_pollVotes[userId],
  };

  @override
  Future<void> setPollVote({
    required String userId,
    required String postId,
    required String option,
  }) async {
    _pollVotes.putIfAbsent(userId, () => {})[postId] = option;
    _pollCountStreams[postId]?.add(_pollCounts(postId));
  }

  Map<String, int> _pollCounts(String postId) {
    final counts = <String, int>{};
    for (final votes in _pollVotes.values) {
      final option = votes[postId];
      if (option != null) {
        counts.update(option, (count) => count + 1, ifAbsent: () => 1);
      }
    }
    return counts;
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
