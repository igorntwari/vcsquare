// User profile screen.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/optimistic_toggle.dart';
import '../../../data/models/listing_model.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../shared/widgets/cards/listing_card.dart';
import '../../../shared/widgets/feedback/empty_state.dart';
import '../../../shared/widgets/feedback/error_state.dart';
import '../../../shared/widgets/feedback/loading_indicator.dart';
import '../../../shared/widgets/layout/app_top_bar.dart';
import '../providers/profile_providers.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_post_card.dart';
import '../widgets/profile_stats_row.dart';
import '../widgets/profile_tab_bar.dart';
import '../widgets/recognition_banner.dart';
import '../widgets/settings_list_tile.dart';

enum _ProfileTab { posts, listings, saved }

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, this.onEditProfile});

  final VoidCallback? onEditProfile;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  _ProfileTab _tab = _ProfileTab.posts;

  // The data these local copies were made from. A refetch replaces them.
  ProfileData? _data;
  Set<String> _likedPostIds = {};
  Set<String> _savedListingIds = {};

  void _adopt(ProfileData data) {
    if (data == _data) return;
    _data = data;
    _likedPostIds = {...data.likedPostIds};
    _savedListingIds = {...data.savedListingIds};
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

  void _toggleLike(String userId, String postId) => optimisticToggle(
    ids: _likedPostIds,
    id: postId,
    update: _update,
    save: (liked) => ref
        .read(postsRepositoryProvider)
        .setLiked(userId: userId, postId: postId, liked: liked),
    onError: _showSaveFailed,
  );

  void _toggleSaved(String userId, String listingId) => optimisticToggle(
    ids: _savedListingIds,
    id: listingId,
    update: _update,
    save: (saved) => ref
        .read(listingsRepositoryProvider)
        .setSaved(userId: userId, listingId: listingId, saved: saved),
    onError: _showSaveFailed,
  );

  // The stored count already includes the user's own like if it was there
  // when the profile loaded, so only adjust for changes since then.
  int _likeCount(PostModel post) =>
      post.likeCount +
      (_likedPostIds.contains(post.id) ? 1 : 0) -
      ((_data?.likedPostIds.contains(post.id) ?? false) ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final loaded = ref.watch(profileProvider);
    if (loaded.value case final value?) _adopt(value);
    final data = _data;

    return Column(
      children: [
        AppTopBar(
          title: AppStrings.navProfile,
          avatarImagePath: user?.avatarPath,
        ),
        Expanded(
          child: data == null
              ? (loaded.hasError
                    ? ErrorState(onRetry: () => ref.invalidate(profileProvider))
                    : const LoadingIndicator())
              : _buildProfile(data),
        ),
      ],
    );
  }

  Widget _buildProfile(ProfileData data) {
    final profile = data.profile;
    final userId = profile.user.id;
    final saved = data.allListings
        .where((listing) => _savedListingIds.contains(listing.id))
        .toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ProfileHeader(
            profile: profile,
            onSettings: () {},
            onStudentId: () {},
            onEdit: widget.onEditProfile,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          sliver: SliverList.list(
            children: [
              ProfileStatsRow(
                posts: data.posts.length,
                listings: data.listings.length,
                followers: profile.followerCount,
                following: profile.followingCount,
              ),
              const SizedBox(height: AppSpacing.md),
              RecognitionBanner(
                title: profile.recognitionTitle,
                subtitle: profile.recognitionSubtitle,
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileTabBar(
                labels: [
                  AppStrings.tabMyPosts,
                  AppStrings.tabListings(data.listings.length),
                  AppStrings.tabSaved,
                ],
                selectedIndex: _tab.index,
                onSelected: (index) =>
                    setState(() => _tab = _ProfileTab.values[index]),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: switch (_tab) {
            _ProfileTab.posts => _buildPosts(data.posts, userId),
            _ProfileTab.listings => _buildListingGrid(
              data.listings,
              userId,
              emptyTitle: AppStrings.noListingsTitle,
              emptyMessage: AppStrings.noListingsMessage,
            ),
            _ProfileTab.saved => _buildListingGrid(
              saved,
              userId,
              emptyTitle: AppStrings.noSavedTitle,
              emptyMessage: AppStrings.noSavedMessage,
            ),
          },
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.lg,
            MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
          ),
          sliver: SliverToBoxAdapter(child: _buildAccountSection()),
        ),
      ],
    );
  }

  Widget _buildPosts(List<PostModel> posts, String userId) {
    if (posts.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyState(
          icon: Icons.edit_note,
          title: AppStrings.noPostsTitle,
          message: AppStrings.noPostsMessage,
        ),
      );
    }
    return SliverList.separated(
      itemCount: posts.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final post = posts[index];
        return ProfilePostCard(
          post: post,
          isLiked: _likedPostIds.contains(post.id),
          likeCount: _likeCount(post),
          onLike: () => _toggleLike(userId, post.id),
        );
      },
    );
  }

  Widget _buildListingGrid(
    List<ListingModel> listings,
    String userId, {
    required String emptyTitle,
    required String emptyMessage,
  }) {
    if (listings.isEmpty) {
      return SliverToBoxAdapter(
        child: EmptyState(
          icon: Icons.storefront_outlined,
          title: emptyTitle,
          message: emptyMessage,
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
      itemBuilder: (context, index) {
        final listing = listings[index];
        return ListingCard(
          listing: listing,
          isFavorite: _savedListingIds.contains(listing.id),
          onFavorite: () => _toggleSaved(userId, listing.id),
        );
      },
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Text(
            AppStrings.accountVerification,
            style: AppTypography.overline.copyWith(color: AppColors.textMuted),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        DecoratedBox(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
            boxShadow: AppShadows.card,
          ),
          child: Material(
            color: AppColors.surface,
            borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                SettingsListTile(
                  icon: Icons.badge_outlined,
                  iconColor: AppColors.success,
                  iconBackground: AppColors.greenSurface,
                  title: AppStrings.studentIdCardTitle,
                  subtitle: AppStrings.studentIdCardSubtitle,
                  isVerified: true,
                  onTap: () {},
                ),
                SettingsListTile(
                  icon: Icons.manage_accounts_outlined,
                  title: AppStrings.securitySettingsTitle,
                  subtitle: AppStrings.securitySettingsSubtitle,
                  onTap: () {},
                ),
                SettingsListTile(
                  icon: Icons.apartment_outlined,
                  iconColor: AppColors.accent,
                  title: AppStrings.campusAccessTitle,
                  subtitle: AppStrings.campusAccessSubtitle,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
