// Home feed screen.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/optimistic_toggle.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../shared/widgets/chips/app_chip.dart';
import '../../../shared/widgets/chips/filter_chip_bar.dart';
import '../../../shared/widgets/feedback/empty_state.dart';
import '../../../shared/widgets/feedback/error_state.dart';
import '../../../shared/widgets/feedback/loading_indicator.dart';
import '../../../shared/widgets/inputs/app_search_bar.dart';
import '../../../shared/widgets/layout/app_top_bar.dart';
import '../providers/home_providers.dart';
import 'post_comments_sheet.dart';
import '../widgets/pinned_announcement_card.dart';
import '../widgets/post_card.dart';
import '../widgets/post_composer_bar.dart';

// Top bar stays fixed; the header, filters and feed scroll beneath it.
// Likes and club joins are kept here so every post from the same club
// updates together, and saved through the repositories.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.onCreatePost});

  final Future<bool?> Function() onCreatePost;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // The feed these local copies were made from. A refetch replaces them.
  HomeFeed? _feed;
  List<PostModel> _posts = const [];
  Set<String> _likedPostIds = {};
  Set<String> _rsvpedPostIds = {};
  Set<String> _savedPostIds = {};
  Map<String, String> _pollVoteOptions = {};
  Set<String> _joinedClubIds = {};
  Set<String> _followedIds = {};
  String _searchQuery = '';
  int _selectedFeedFilter = 0;

  List<PostModel> get _visiblePosts {
    final query = _searchQuery.trim().toLowerCase();
    return _posts.where((post) {
      final matchesQuery =
          query.isEmpty ||
          [
            post.title,
            post.body,
            post.topic,
            post.author.name,
            post.author.handle,
          ].whereType<String>().any(
            (value) => value.toLowerCase().contains(query),
          );
      if (!matchesQuery) return false;

      return switch (_selectedFeedFilter) {
        1 =>
          _joinedClubIds.contains(post.author.id) ||
              _followedIds.contains(post.author.id),
        2 => post.author.isOfficial,
        3 => post.event != null || post.author.isClub,
        4 =>
          '${post.topic ?? ''} ${post.title ?? ''} ${post.body}'
              .toLowerCase()
              .contains(RegExp(r'tech|innovation|hackathon|coding')),
        _ => true,
      };
    }).toList();
  }

  void _adopt(HomeFeed feed) {
    if (feed == _feed) return;
    _feed = feed;
    // Pinned posts always sit at the top of the feed.
    _posts = [
      ...feed.posts.where((post) => post.isPinned),
      ...feed.posts.where((post) => !post.isPinned),
    ];
    _likedPostIds = {...feed.likedPostIds};
    _rsvpedPostIds = {...feed.rsvpedPostIds};
    _savedPostIds = {...feed.savedPostIds};
    _pollVoteOptions = {...feed.pollVoteOptions};
    _joinedClubIds = {...feed.joinedIds};
    _followedIds = {...feed.followedIds};
  }

  void _update(VoidCallback change) {
    if (mounted) setState(change);
  }

  void _showSaveFailed() {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text(AppStrings.saveFailed)));
  }

  void _toggleLike(PostModel post) {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return;
    optimisticToggle(
      ids: _likedPostIds,
      id: post.id,
      update: _update,
      save: (liked) => ref
          .read(postsRepositoryProvider)
          .setLiked(userId: userId, postId: post.id, liked: liked),
      onError: _showSaveFailed,
    );
  }

  void _toggleJoin(PostModel post) {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return;
    optimisticToggle(
      ids: _joinedClubIds,
      id: post.author.id,
      update: _update,
      save: (joined) => ref
          .read(exploreRepositoryProvider)
          .setJoined(userId: userId, groupId: post.author.id, joined: joined),
      onError: _showSaveFailed,
    );
  }

  void _toggleRsvp(PostModel post) {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return;
    optimisticToggle(
      ids: _rsvpedPostIds,
      id: post.id,
      update: _update,
      save: (rsvped) => ref
          .read(postsRepositoryProvider)
          .setRsvp(userId: userId, postId: post.id, rsvped: rsvped),
      onError: _showSaveFailed,
    );
  }

  void _toggleSave(PostModel post) {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return;
    optimisticToggle(
      ids: _savedPostIds,
      id: post.id,
      update: _update,
      save: (saved) => ref
          .read(postsRepositoryProvider)
          .setSaved(userId: userId, postId: post.id, saved: saved),
      onError: _showSaveFailed,
    );
  }

  Future<void> _votePoll(PostModel post, String option) async {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null || _pollVoteOptions[post.id] == option) return;
    final previous = _pollVoteOptions[post.id];
    setState(() => _pollVoteOptions[post.id] = option);
    try {
      await ref.read(postsRepositoryProvider).setPollVote(
        userId: userId,
        postId: post.id,
        option: option,
      );
    } catch (_) {
      if (previous == null) {
        _pollVoteOptions.remove(post.id);
      } else {
        _pollVoteOptions[post.id] = previous;
      }
      _showSaveFailed();
      if (mounted) setState(() {});
    }
  }

  Future<void> _sharePost(PostModel post) async {
    final text = [post.title, post.body].whereType<String>().join('\n');
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text(AppStrings.postCopied)));
  }

  Future<void> _openComments(PostModel post) async {
    final addedComment = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => PostCommentsSheet(post: post),
    );
    if (addedComment == true) ref.invalidate(homeFeedProvider);
  }

  // The stored count already includes the user's own like if it was there
  // when the feed loaded, so only adjust for changes since then.
  int _likeCount(PostModel post) {
    final wasLiked = _feed?.likedPostIds.contains(post.id) ?? false;
    final isLiked = _likedPostIds.contains(post.id);
    return post.likeCount + (isLiked ? 1 : 0) - (wasLiked ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final feed = ref.watch(homeFeedProvider);
    if (feed.value case final loaded?) _adopt(loaded);

    return Column(
      children: [
        AppTopBar(title: AppStrings.navHome, avatarImagePath: user?.avatarPath),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(user?.avatarPath, user?.isOnline ?? false),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: FilterChipBar(
                    chips: [
                      AppChip(
                        label: AppStrings.filterAllCampus,
                        icon: Icons.public,
                      ),
                      AppChip(label: AppStrings.filterMyFeed),
                      AppChip(
                        label: AppStrings.filterOfficialAnnouncements,
                        dotColor: AppColors.accent,
                      ),
                      AppChip(label: AppStrings.filterStudentLife),
                      AppChip(
                        label: AppStrings.filterTechInnovation,
                        icon: Icons.lightbulb_outline,
                      ),
                    ],
                    onSelected: (index) =>
                        setState(() => _selectedFeedFilter = index),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  // Clears the floating bottom nav bar.
                  MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
                ),
                sliver: _feed == null
                    ? SliverToBoxAdapter(
                        child: feed.hasError
                            ? ErrorState(
                                onRetry: () => ref.invalidate(homeFeedProvider),
                              )
                            : const LoadingIndicator(),
                      )
                    : _visiblePosts.isEmpty
                    ? const SliverToBoxAdapter(
                        child: EmptyState(
                          icon: Icons.search_off,
                          title: AppStrings.noMatchingPostsTitle,
                          message: AppStrings.noMatchingPostsMessage,
                        ),
                      )
                    : SliverList.separated(
                        itemCount: _visiblePosts.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.lg),
                        itemBuilder: (context, index) =>
                            _buildPost(_visiblePosts[index]),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Search and composer on the navy band that continues the top bar.
  Widget _buildHeader(String? avatarPath, bool isOnline) {
    return ColoredBox(
      color: AppColors.topBarBackground,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          children: [
            AppSearchBar(
              hintText: AppStrings.searchHint,
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: AppSpacing.sm),
            PostComposerBar(
              avatarImagePath: avatarPath,
              isOnline: isOnline,
              onComposeTap: () async {
                if (kDebugMode) {
                  debugPrint(
                    '[Home] Composer tapped; opening create-post route.',
                  );
                }
                final created = await widget.onCreatePost();
                if (kDebugMode) {
                  debugPrint('[Home] Create-post route returned: $created');
                }
                if (created == true) {
                  ref.invalidate(homeFeedProvider);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text(AppStrings.postPublished)),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPost(PostModel post) {
    final isLiked = _likedPostIds.contains(post.id);
    final likeCount = _likeCount(post);

    if (post.isPinned) {
      return PinnedAnnouncementCard(
        post: post,
        isLiked: isLiked,
        likeCount: likeCount,
        isRsvped: _rsvpedPostIds.contains(post.id),
        onLike: () => _toggleLike(post),
        onRsvp: () => _toggleRsvp(post),
        onComment: () => _openComments(post),
        onShare: () => _sharePost(post),
        isSaved: _savedPostIds.contains(post.id),
        onSave: () => _toggleSave(post),
      );
    }
    return PostCard(
      post: post,
      isLiked: isLiked,
      likeCount: likeCount,
      isJoined: _joinedClubIds.contains(post.author.id),
      onLike: () => _toggleLike(post),
      onJoin: () => _toggleJoin(post),
      onComment: () => _openComments(post),
      onShare: () => _sharePost(post),
      isSaved: _savedPostIds.contains(post.id),
      onSave: () => _toggleSave(post),
      selectedPollOption: _pollVoteOptions[post.id],
      onVote: (option) => _votePoll(post, option),
    );
  }
}
