// Home feed screen.
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/dummy/dummy_posts.dart';
import '../../../data/dummy/dummy_users.dart';
import '../../../data/models/post_model.dart';
import '../../../shared/widgets/chips/app_chip.dart';
import '../../../shared/widgets/chips/filter_chip_bar.dart';
import '../../../shared/widgets/inputs/app_search_bar.dart';
import '../../../shared/widgets/layout/app_top_bar.dart';
import '../widgets/pinned_announcement_card.dart';
import '../widgets/post_card.dart';
import '../widgets/post_composer_bar.dart';

// Top bar stays fixed; the header, filters and feed scroll beneath it.
// Likes and club joins are kept here so every post from the same club
// updates together.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Pinned posts always sit at the top of the feed.
  final List<PostModel> _posts = [
    ...dummyPosts.where((post) => post.isPinned),
    ...dummyPosts.where((post) => !post.isPinned),
  ];

  late final Set<String> _likedPostIds = {
    for (final post in dummyPosts)
      if (post.isLiked) post.id,
  };

  late final Set<String> _joinedClubIds = {
    for (final user in dummyUsers)
      if (user.isClub && user.isJoined) user.id,
  };

  void _toggleLike(PostModel post) {
    setState(() {
      if (!_likedPostIds.remove(post.id)) _likedPostIds.add(post.id);
    });
  }

  void _toggleJoin(PostModel post) {
    final clubId = post.author.id;
    setState(() {
      if (!_joinedClubIds.remove(clubId)) _joinedClubIds.add(clubId);
    });
  }

  // The dummy count already includes the user's own like if it was there
  // when the feed loaded, so only adjust for changes since then.
  int _likeCount(PostModel post) {
    final isLiked = _likedPostIds.contains(post.id);
    return post.likeCount + (isLiked ? 1 : 0) - (post.isLiked ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTopBar(
          title: AppStrings.navHome,
          avatarImagePath: dummyCurrentUser.avatarPath,
          hasUnreadNotifications: true,
        ),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
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
                sliver: SliverList.separated(
                  itemCount: _posts.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.lg),
                  itemBuilder: (context, index) => _buildPost(_posts[index]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Search and composer on the navy band that continues the top bar.
  Widget _buildHeader() {
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
            PostComposerBar(
              avatarImagePath: dummyCurrentUser.avatarPath,
              isOnline: dummyCurrentUser.isOnline,
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
