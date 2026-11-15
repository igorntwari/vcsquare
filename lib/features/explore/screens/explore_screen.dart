// Explore screen for discovering topics, handles, communities and people.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/optimistic_toggle.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../shared/widgets/chips/app_chip.dart';
import '../../../shared/widgets/chips/filter_chip_bar.dart';
import '../../../shared/widgets/feedback/error_state.dart';
import '../../../shared/widgets/feedback/loading_indicator.dart';
import '../../../shared/widgets/inputs/app_search_bar.dart';
import '../../../shared/widgets/layout/app_top_bar.dart';
import '../../../shared/widgets/layout/section_header.dart';
import '../providers/explore_providers.dart';
import '../widgets/community_card.dart';
import '../widgets/official_handle_card.dart';
import '../widgets/person_suggestion_tile.dart';
import '../widgets/trending_topics.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  // The data these local copies were made from. A refetch replaces them.
  ExploreData? _data;
  Set<String> _followedHandleIds = {};
  Set<String> _joinedCommunityIds = {};

  // Connection requests aren't stored anywhere yet.
  final Set<String> _requestedPeerIds = {};

  void _adopt(ExploreData data) {
    if (data == _data) return;
    _data = data;
    _followedHandleIds = {...data.followingIds};
    _joinedCommunityIds = {...data.joinedIds};
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

  // Adds the id if missing, removes it if present.
  void _toggle(Set<String> ids, String id) {
    setState(() {
      if (!ids.remove(id)) ids.add(id);
    });
  }

  void _toggleFollow(String handleId) {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return;
    optimisticToggle(
      ids: _followedHandleIds,
      id: handleId,
      update: _update,
      save: (following) => ref
          .read(exploreRepositoryProvider)
          .setFollowing(
            userId: userId,
            targetId: handleId,
            following: following,
          ),
      onError: _showSaveFailed,
    );
  }

  void _toggleJoin(String communityId) {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return;
    optimisticToggle(
      ids: _joinedCommunityIds,
      id: communityId,
      update: _update,
      save: (joined) => ref
          .read(exploreRepositoryProvider)
          .setJoined(userId: userId, groupId: communityId, joined: joined),
      onError: _showSaveFailed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final explore = ref.watch(exploreProvider);
    if (explore.value case final loaded?) _adopt(loaded);
    final data = _data;

    return Column(
      children: [
        AppTopBar(
          title: AppStrings.navExplore,
          avatarImagePath: user?.avatarPath,
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
              if (data == null)
                SliverToBoxAdapter(
                  child: explore.hasError
                      ? ErrorState(
                          onRetry: () => ref.invalidate(exploreProvider),
                        )
                      : const LoadingIndicator(),
                )
              else ...[
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
                        TrendingTopics(topics: data.trendingTopics),
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
                SliverToBoxAdapter(child: _buildHandlesRow(data)),
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
                      for (final community in data.communities) ...[
                        CommunityCard(
                          community: community,
                          isJoined: _joinedCommunityIds.contains(community.id),
                          onJoin: () => _toggleJoin(community.id),
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
                      for (final suggestion in data.peerSuggestions) ...[
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
  Widget _buildHandlesRow(ExploreData data) {
    return SizedBox(
      height: AppSizes.handleCardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: data.officialHandles.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final handle = data.officialHandles[index];
          return OfficialHandleCard(
            handle: handle,
            isFollowing: _followedHandleIds.contains(handle.id),
            onFollow: () => _toggleFollow(handle.id),
          );
        },
      ),
    );
  }
}
