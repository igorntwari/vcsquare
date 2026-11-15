// Home feed screen.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/optimistic_toggle.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../shared/widgets/chips/app_chip.dart';
import '../../../shared/widgets/chips/filter_chip_bar.dart';
import '../../../shared/widgets/feedback/error_state.dart';
import '../../../shared/widgets/feedback/loading_indicator.dart';
import '../../../shared/widgets/inputs/app_search_bar.dart';
import '../../../shared/widgets/layout/app_top_bar.dart';
import '../providers/home_providers.dart';
import '../widgets/pinned_announcement_card.dart';
import '../widgets/post_card.dart';
import '../widgets/post_composer_bar.dart';

// Top bar stays fixed; the header, filters and feed scroll beneath it.
// Likes and club joins are kept here so every post from the same club
// updates together, and saved through the repositories.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // The feed these local copies were made from. A refetch replaces them.
  HomeFeed? _feed;
  List<PostModel> _posts = const [];
  Set<String> _likedPostIds = {};
  Set<String> _joinedClubIds = {};

  void _adopt(HomeFeed feed) {
    if (feed == _feed) return;
    _feed = feed;
    // Pinned posts always sit at the top of the feed.
    _posts = [
      ...feed.posts.where((post) => post.isPinned),
      ...feed.posts.where((post) => !post.isPinned),
    ];
    _likedPostIds = {...feed.likedPostIds};
    _joinedClubIds = {...feed.joinedIds};
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
              const SliverToBoxAdapter(
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
                    : SliverList.separated(
                        itemCount: _posts.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.lg),
                        itemBuilder: (context, index) =>
                            _buildPost(_posts[index]),
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
            const AppSearchBar(hintText: AppStrings.searchHint),
            const SizedBox(height: AppSpacing.sm),
            PostComposerBar(avatarImagePath: avatarPath, isOnline: isOnline),
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
        onLike: () => _toggleLike(post),
      );
    }
    return PostCard(
      post: post,
      isLiked: isLiked,
      likeCount: likeCount,
      isJoined: _joinedClubIds.contains(post.author.id),
      onLike: () => _toggleLike(post),
      onJoin: () => _toggleJoin(post),
    );
  }
}
