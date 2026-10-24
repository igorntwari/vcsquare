// User profile screen.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/dummy/dummy_listings.dart';
import '../../../data/dummy/dummy_posts.dart';
import '../../../data/dummy/dummy_profile.dart';
import '../../../data/models/listing_model.dart';
import '../../../data/models/post_model.dart';
import '../../../shared/widgets/cards/listing_card.dart';
import '../../../shared/widgets/feedback/empty_state.dart';
import '../../../shared/widgets/layout/app_top_bar.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_post_card.dart';
import '../widgets/profile_stats_row.dart';
import '../widgets/profile_tab_bar.dart';
import '../widgets/recognition_banner.dart';
import '../widgets/settings_list_tile.dart';

enum _ProfileTab { posts, listings, saved }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  _ProfileTab _tab = _ProfileTab.posts;

  final List<PostModel> _myPosts = dummyPosts
      .where((post) => post.author.id == dummyProfile.user.id)
      .toList();

  final List<ListingModel> _myListings = dummyListings
      .where((listing) => listing.seller.id == dummyProfile.user.id)
      .toList();

  late final Set<String> _likedPostIds = {
    for (final post in _myPosts)
      if (post.isLiked) post.id,
  };

  late final Set<String> _savedListingIds = {
    for (final listing in dummyListings)
      if (listing.isFavorited) listing.id,
  };

  // Adds the id if missing, removes it if present.
  void _toggle(Set<String> ids, String id) {
    setState(() {
      if (!ids.remove(id)) ids.add(id);
    });
  }

  int _likeCount(PostModel post) =>
      post.likeCount +
      (_likedPostIds.contains(post.id) ? 1 : 0) -
      (post.isLiked ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    final saved = dummyListings
        .where((listing) => _savedListingIds.contains(listing.id))
        .toList();

    return Column(
      children: [
        AppTopBar(
          title: AppStrings.navProfile,
          avatarImagePath: dummyProfile.user.avatarPath,
          hasUnreadNotifications: true,
        ),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ProfileHeader(
                  profile: dummyProfile,
                  onSettings: () {},
                  onStudentId: () {},
                  onEdit: () {},
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                sliver: SliverList.list(
                  children: [
                    ProfileStatsRow(
                      posts: _myPosts.length,
                      listings: _myListings.length,
                      followers: dummyProfile.followerCount,
                      following: dummyProfile.followingCount,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    RecognitionBanner(
                      title: dummyProfile.recognitionTitle,
                      subtitle: dummyProfile.recognitionSubtitle,
                      onTap: () {},
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ProfileTabBar(
                      labels: [
                        AppStrings.tabMyPosts,
                        AppStrings.tabListings(_myListings.length),
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
                  _ProfileTab.posts => _buildPosts(),
                  _ProfileTab.listings => _buildListingGrid(
                    _myListings,
                    emptyTitle: AppStrings.noListingsTitle,
                    emptyMessage: AppStrings.noListingsMessage,
                  ),
                  _ProfileTab.saved => _buildListingGrid(
                    saved,
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
          ),
        ),
      ],
    );
  }

  Widget _buildPosts() {
    if (_myPosts.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyState(
          icon: Icons.edit_note,
          title: AppStrings.noPostsTitle,
          message: AppStrings.noPostsMessage,
        ),
      );
    }
    return SliverList.separated(
      itemCount: _myPosts.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final post = _myPosts[index];
        return ProfilePostCard(
          post: post,
          isLiked: _likedPostIds.contains(post.id),
          likeCount: _likeCount(post),
          onLike: () => _toggle(_likedPostIds, post.id),
        );
      },
    );
  }

  Widget _buildListingGrid(
    List<ListingModel> listings, {
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
          onFavorite: () => _toggle(_savedListingIds, listing.id),
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
            borderRadius: const BorderRadius.all(
              Radius.circular(AppRadius.md),
            ),
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
