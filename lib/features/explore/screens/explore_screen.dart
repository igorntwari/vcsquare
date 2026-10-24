// Explore screen for discovering topics, handles, communities and people.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/dummy/dummy_communities.dart';
import '../../../data/dummy/dummy_official_handles.dart';
import '../../../data/dummy/dummy_peer_suggestions.dart';
import '../../../data/dummy/dummy_trending_topics.dart';
import '../../../data/dummy/dummy_users.dart';
import '../../../shared/widgets/chips/app_chip.dart';
import '../../../shared/widgets/chips/filter_chip_bar.dart';
import '../../../shared/widgets/inputs/app_search_bar.dart';
import '../../../shared/widgets/layout/app_top_bar.dart';
import '../../../shared/widgets/layout/section_header.dart';
import '../widgets/community_card.dart';
import '../widgets/official_handle_card.dart';
import '../widgets/person_suggestion_tile.dart';
import '../widgets/trending_topics.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late final Set<String> _followedHandleIds = {
    for (final handle in dummyOfficialHandles)
      if (handle.isFollowing) handle.id,
  };

  late final Set<String> _joinedCommunityIds = {
    for (final community in dummyCommunities)
      if (community.isJoined) community.id,
  };

  final Set<String> _requestedPeerIds = {};

  // Adds the id if missing, removes it if present.
  void _toggle(Set<String> ids, String id) {
    setState(() {
      if (!ids.remove(id)) ids.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTopBar(
          title: AppStrings.navExplore,
          avatarImagePath: dummyCurrentUser.avatarPath,
          hasUnreadNotifications: true,
        ),
        Expanded(
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: ColoredBox(
                  color: AppColors.topBarBackground,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: AppSearchBar(hintText: AppStrings.exploreSearchHint),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: AppSpacing.lg),
                  child: FilterChipBar(
                    chips: [
                      AppChip(label: AppStrings.filterAll),
                      AppChip(label: AppStrings.filterPosts),
                      AppChip(label: AppStrings.filterListings),
                      AppChip(label: AppStrings.filterPeople),
                      AppChip(label: AppStrings.filterCommunities),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SectionHeader(
                        title: AppStrings.trendingTitle,
                        trailing: _buildLivePulse(),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const TrendingTopics(topics: dummyTrendingTopics),
                      const SizedBox(height: AppSpacing.xl),
                      SectionHeader(
                        kicker: AppStrings.verifiedInstitutional,
                        kickerColor: AppColors.success,
                        title: AppStrings.officialHandles,
                        actionLabel: AppStrings.seeDirectory,
                        onAction: () {},
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _buildHandlesRow()),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xl,
                  AppSpacing.lg,
                  MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
                ),
                sliver: SliverList.list(
                  children: [
                    SectionHeader(
                      kicker: AppStrings.campusHubs,
                      kickerColor: AppColors.kickerWarm,
                      title: AppStrings.discoverCommunities,
                      actionLabel: AppStrings.exploreAll,
                      actionColor: AppColors.textMuted,
                      onAction: () {},
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    for (final community in dummyCommunities) ...[
                      CommunityCard(
                        community: community,
                        isJoined: _joinedCommunityIds.contains(community.id),
                        onJoin: () =>
                            _toggle(_joinedCommunityIds, community.id),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    SectionHeader(
                      kicker: AppStrings.peerNetwork,
                      title: AppStrings.peopleYouMayKnow,
                      actionLabel: AppStrings.syncContacts,
                      onAction: () {},
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    for (final suggestion in dummyPeerSuggestions) ...[
                      PersonSuggestionTile(
                        suggestion: suggestion,
                        isRequested: _requestedPeerIds.contains(
                          suggestion.user.id,
                        ),
                        onConnect: () =>
                            _toggle(_requestedPeerIds, suggestion.user.id),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Red dot with "Live Pulse" next to the trending heading.
  Widget _buildLivePulse() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSizes.statusDot,
          height: AppSizes.statusDot,
          decoration: const BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          AppStrings.livePulse,
          style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }

  // Sideways list of official handle cards that bleeds to the screen edges.
  Widget _buildHandlesRow() {
    return SizedBox(
      height: AppSizes.handleCardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: dummyOfficialHandles.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final handle = dummyOfficialHandles[index];
          return OfficialHandleCard(
            handle: handle,
            isFollowing: _followedHandleIds.contains(handle.id),
            onFollow: () => _toggle(_followedHandleIds, handle.id),
          );
        },
      ),
    );
  }
}
