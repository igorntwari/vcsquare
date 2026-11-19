// Another student's profile, with a Follow button.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/listing_model.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../shared/widgets/cards/listing_card.dart';
import '../../../shared/widgets/feedback/app_snack_bar.dart';
import '../../../shared/widgets/feedback/empty_state.dart';
import '../../../shared/widgets/feedback/error_state.dart';
import '../../../shared/widgets/feedback/loading_indicator.dart';
import '../providers/profile_providers.dart';
import '../widgets/profile_action_button.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_post_card.dart';
import '../widgets/profile_stats_row.dart';
import '../widgets/profile_tab_bar.dart';

class StudentProfileScreen extends ConsumerStatefulWidget {
  const StudentProfileScreen({
    super.key,
    required this.userId,
    this.onBack,
    this.onOpenListing,
  });

  final String userId;
  final VoidCallback? onBack;
  final ValueChanged<ListingModel>? onOpenListing;

  @override
  ConsumerState<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState extends ConsumerState<StudentProfileScreen> {
  // 0 = posts, 1 = listings.
  final ValueNotifier<int> _tab = ValueNotifier(0);

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Future<void> _toggleFollow(String myId, bool following) async {
    try {
      await ref
          .read(followRepositoryProvider)
          .setFollowingStudent(
            userId: myId,
            studentId: widget.userId,
            following: following,
          );
    } catch (_) {
      if (mounted) showAppSnackBar(context, AppStrings.saveFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loaded = ref.watch(studentProfileProvider(widget.userId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          tooltip: AppStrings.goBack,
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: switch (loaded) {
        AsyncData(:final value) => _buildProfile(value),
        AsyncError() => ErrorState(
          onRetry: () => ref.invalidate(studentProfileProvider(widget.userId)),
        ),
        _ => const LoadingIndicator(),
      },
    );
  }

  Widget _buildProfile(StudentProfileData data) {
    final myId = ref.watch(currentUserProvider).value?.id;
    final isFollowing =
        ref.watch(followingIdsProvider).value?.contains(widget.userId) ?? false;

    return RefreshIndicator(
      onRefresh: () =>
          ref.refresh(studentProfileProvider(widget.userId).future),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ProfileHeader(
              profile: data.profile,
              actions: [
                if (myId != null && myId != widget.userId)
                  ProfileActionButton(
                    icon: isFollowing ? Icons.check : Icons.person_add_alt,
                    label: isFollowing
                        ? AppStrings.following
                        : AppStrings.follow,
                    background: isFollowing
                        ? AppColors.greenSurface
                        : AppColors.primary,
                    foreground: isFollowing
                        ? AppColors.success
                        : AppColors.textOnDark,
                    onTap: () => _toggleFollow(myId, !isFollowing),
                  ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: SliverList.list(
              children: [
                ProfileStatsRow(
                  posts: data.posts.length,
                  listings: data.listings.length,
                  followers:
                      ref.watch(followerCountProvider(widget.userId)).value ??
                      0,
                  following:
                      ref.watch(followingCountProvider(widget.userId)).value ??
                      0,
                ),
                const SizedBox(height: AppSpacing.lg),
                ValueListenableBuilder<int>(
                  valueListenable: _tab,
                  builder: (context, tab, _) => ProfileTabBar(
                    labels: [
                      AppStrings.tabPosts,
                      AppStrings.tabListings(data.listings.length),
                    ],
                    selectedIndex: tab,
                    onSelected: (index) => _tab.value = index,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
          ValueListenableBuilder<int>(
            valueListenable: _tab,
            builder: (context, tab, _) => SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
              ),
              sliver: tab == 0
                  ? _buildPosts(data.posts)
                  : _buildListings(data.listings),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPosts(List<PostModel> posts) {
    if (posts.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyState(
          icon: Icons.edit_note,
          title: AppStrings.noStudentPostsTitle,
          message: AppStrings.noStudentPostsMessage,
        ),
      );
    }
    return SliverList.separated(
      itemCount: posts.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) => ProfilePostCard(
        post: posts[index],
        isLiked: false,
        likeCount: posts[index].likeCount,
      ),
    );
  }

  Widget _buildListings(List<ListingModel> listings) {
    if (listings.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyState(
          icon: Icons.storefront_outlined,
          title: AppStrings.noStudentListingsTitle,
          message: AppStrings.noStudentListingsMessage,
        ),
      );
    }
    return SliverGrid.builder(
      itemCount: listings.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        mainAxisExtent: AppSizes.listingCardHeight,
      ),
      itemBuilder: (context, index) => ListingCard(
        listing: listings[index],
        onTap: () => widget.onOpenListing?.call(listings[index]),
      ),
    );
  }
}
