// Explore screen for discovering topics, handles, communities and people.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/optimistic_toggle.dart';
import '../../../data/models/community_model.dart';
import '../../../data/models/listing_model.dart';
import '../../../data/models/official_handle_model.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../shared/widgets/cards/app_card.dart';
import '../../../shared/widgets/chips/app_chip.dart';
import '../../../shared/widgets/chips/filter_chip_bar.dart';
import '../../../shared/widgets/feedback/empty_state.dart';
import '../../../shared/widgets/feedback/error_state.dart';
import '../../../shared/widgets/feedback/loading_indicator.dart';
import '../../../shared/widgets/inputs/app_search_bar.dart';
import '../../../shared/widgets/layout/app_top_bar.dart';
import '../../../shared/widgets/layout/section_header.dart';
import '../providers/explore_providers.dart';
import '../widgets/community_card.dart';
import '../widgets/explore_listing_result_tile.dart';
import '../widgets/explore_post_result_tile.dart';
import '../widgets/official_handle_card.dart';
import '../widgets/person_suggestion_tile.dart';
import '../widgets/students_on_campus_section.dart';
import '../widgets/trending_topics.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({
    super.key,
    this.onOpenCommunity,
    this.onOpenOfficialHandle,
    this.onOpenStudent,
  });

  final void Function(CommunityModel, bool, VoidCallback)? onOpenCommunity;
  final void Function(OfficialHandleModel, bool, VoidCallback)?
  onOpenOfficialHandle;
  final ValueChanged<UserModel>? onOpenStudent;

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  // The data these local copies were made from. A refetch replaces them.
  ExploreData? _data;
  Set<String> _followedHandleIds = {};
  Set<String> _joinedCommunityIds = {};
  String _searchQuery = '';
  String? _trendingTag;
  int _selectedExploreFilter = 0;

  final Set<String> _requestedPeerIds = {};

  bool get _showSearchResults =>
      _searchQuery.trim().isNotEmpty ||
      _trendingTag != null ||
      _selectedExploreFilter != 0;

  void _adopt(ExploreData data) {
    if (data == _data) return;
    _data = data;
    _followedHandleIds = {...data.followingIds};
    _joinedCommunityIds = {...data.joinedIds};
    _requestedPeerIds
      ..clear()
      ..addAll(data.requestedPeerIds);
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

  void _toggleConnectionRequest(String peerId) {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return;
    optimisticToggle(
      ids: _requestedPeerIds,
      id: peerId,
      update: _update,
      save: (requested) => ref
          .read(exploreRepositoryProvider)
          .setConnectionRequest(
            userId: userId,
            peerId: peerId,
            requested: requested,
          ),
      onError: _showSaveFailed,
    );
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
          child: RefreshIndicator(
            onRefresh: () => ref.refresh(exploreProvider.future),
          child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: ColoredBox(
                  color: AppColors.topBarBackground,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: AppSearchBar(
                      hintText: AppStrings.exploreSearchHint,
                      onChanged: (value) => setState(() {
                        _searchQuery = value;
                        _trendingTag = null;
                      }),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.lg),
                  child: FilterChipBar(
                    key: ValueKey(_selectedExploreFilter),
                    initialIndex: _selectedExploreFilter,
                    chips: const [
                      AppChip(label: AppStrings.filterAll),
                      AppChip(label: AppStrings.filterPosts),
                      AppChip(label: AppStrings.filterListings),
                      AppChip(label: AppStrings.filterPeople),
                      AppChip(label: AppStrings.filterCommunities),
                    ],
                    onSelected: (index) => setState(() {
                      _selectedExploreFilter = index;
                      _trendingTag = null;
                    }),
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
              else if (_showSearchResults)
                _buildSearchResults(data)
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
                        TrendingTopics(
                          topics: data.trendingTopics,
                          onTopicTap: (topic) => setState(() {
                            _trendingTag = topic.tag;
                            _searchQuery = '';
                            _selectedExploreFilter = 1;
                          }),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        SectionHeader(
                          kicker: AppStrings.verifiedInstitutional,
                          kickerColor: AppColors.success,
                          title: AppStrings.officialHandles,
                          actionLabel: AppStrings.seeDirectory,
                          onAction: () =>
                              setState(() => _selectedExploreFilter = 3),
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
                        onAction: () =>
                            setState(() => _selectedExploreFilter = 4),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      for (final community in data.communities) ...[
                        CommunityCard(
                          community: community,
                            isJoined: _joinedCommunityIds.contains(
                              community.id,
                            ),
                          onJoin: () => _toggleJoin(community.id),
                          onTap: () => widget.onOpenCommunity?.call(
                            community,
                            _joinedCommunityIds.contains(community.id),
                            () => _toggleJoin(community.id),
                          ),
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
                              _toggleConnectionRequest(suggestion.user.id),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      StudentsOnCampusSection(
                        onOpenStudent: widget.onOpenStudent,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        ),
      ],
    );
  }

  SliverPadding _buildSearchResults(ExploreData data) {
    final query = _searchQuery.trim().toLowerCase();
    final posts = data.posts
        .where((post) => _matchesPost(post, query))
        .toList();
    final listings = data.listings
        .where(
          (listing) =>
              listing.status == 'active' && _matchesListing(listing, query),
        )
        .toList();
    final people = data.peerSuggestions.where((suggestion) {
      return _matches(query, [
        suggestion.user.name,
        suggestion.user.handle,
        suggestion.program,
        suggestion.focus,
        suggestion.sharedInterest,
      ]);
    }).toList();
    final handles = data.officialHandles.where((handle) {
      return _matches(query, [
        handle.name,
        handle.handle,
        handle.category,
        handle.description,
      ]);
    }).toList();
    final communities = data.communities.where((community) {
      return _matches(query, [
        community.name,
        community.tag,
        community.description,
        community.activity,
      ]);
    }).toList();

    final children = <Widget>[];
    switch (_selectedExploreFilter) {
      case 1:
        _appendSection(children, AppStrings.filterPosts, [
          for (final post in posts) ExplorePostResultTile(post: post),
        ]);
      case 2:
        _appendSection(children, AppStrings.filterListings, [
          for (final listing in listings)
            ExploreListingResultTile(listing: listing),
        ]);
      case 3:
        _appendSection(children, AppStrings.filterPeople, [
          for (final suggestion in people)
            PersonSuggestionTile(
              suggestion: suggestion,
              isRequested: _requestedPeerIds.contains(suggestion.user.id),
              onConnect: () => _toggleConnectionRequest(suggestion.user.id),
            ),
          for (final handle in handles)
            _buildHandleResult(
              handle,
              onTap: () => widget.onOpenOfficialHandle?.call(
                handle,
                _followedHandleIds.contains(handle.id),
                () => _toggleFollow(handle.id),
              ),
            ),
        ]);
      case 4:
        _appendSection(children, AppStrings.filterCommunities, [
          for (final community in communities)
            CommunityCard(
              community: community,
              isJoined: _joinedCommunityIds.contains(community.id),
              onJoin: () => _toggleJoin(community.id),
              onTap: () => widget.onOpenCommunity?.call(
                community,
                _joinedCommunityIds.contains(community.id),
                () => _toggleJoin(community.id),
              ),
            ),
        ]);
      default:
        _appendSection(children, AppStrings.filterPosts, [
          for (final post in posts) ExplorePostResultTile(post: post),
        ]);
        _appendSection(children, AppStrings.filterListings, [
          for (final listing in listings)
            ExploreListingResultTile(listing: listing),
        ]);
        _appendSection(children, AppStrings.filterPeople, [
          for (final suggestion in people)
            PersonSuggestionTile(
              suggestion: suggestion,
              isRequested: _requestedPeerIds.contains(suggestion.user.id),
              onConnect: () => _toggleConnectionRequest(suggestion.user.id),
            ),
          for (final handle in handles)
            _buildHandleResult(
              handle,
              onTap: () => widget.onOpenOfficialHandle?.call(
                handle,
                _followedHandleIds.contains(handle.id),
                () => _toggleFollow(handle.id),
              ),
            ),
        ]);
        _appendSection(children, AppStrings.filterCommunities, [
          for (final community in communities)
            CommunityCard(
              community: community,
              isJoined: _joinedCommunityIds.contains(community.id),
              onJoin: () => _toggleJoin(community.id),
              onTap: () => widget.onOpenCommunity?.call(
                community,
                _joinedCommunityIds.contains(community.id),
                () => _toggleJoin(community.id),
              ),
            ),
        ]);
    }

    if (children.isEmpty) {
      children.add(
        const EmptyState(
          icon: Icons.search_off,
          title: AppStrings.noExploreResultsTitle,
          message: AppStrings.noExploreResultsMessage,
        ),
      );
    }
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
      ),
      sliver: SliverList.list(children: children),
    );
  }

  void _appendSection(List<Widget> children, String title, List<Widget> items) {
    if (items.isEmpty) return;
    if (children.isNotEmpty) {
      children.add(const SizedBox(height: AppSpacing.lg));
    }
    children.add(SectionHeader(title: title));
    children.add(const SizedBox(height: AppSpacing.sm));
    for (final item in items) {
      children.add(item);
      children.add(const SizedBox(height: AppSpacing.sm));
    }
  }

  Widget _buildHandleResult(OfficialHandleModel handle, {VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
        child: AppCard(
          child: Row(
            children: [
              Container(
                width: AppSizes.avatarMd,
                height: AppSizes.avatarMd,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: AppColors.textOnDark,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      handle.name,
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      handle.handle,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      handle.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _matches(String query, List<String?> values) =>
      query.isEmpty ||
      values.whereType<String>().any(
        (value) => value.toLowerCase().contains(query),
      );

  bool _matchesPost(PostModel post, String query) {
    if (_trendingTag != null) {
      final terms = _topicTerms(_trendingTag!);
      final content = '${post.topic ?? ''} ${post.title ?? ''} ${post.body}'
          .toLowerCase();
      return terms.any(content.contains);
    }
    return _matches(query, [
      post.title,
      post.body,
      post.topic,
      post.author.name,
      post.author.handle,
    ]);
  }

  bool _matchesListing(ListingModel listing, String query) => _matches(query, [
    listing.title,
    listing.details,
    listing.seller.name,
    listing.seller.handle,
    listing.tag,
  ]);

  List<String> _topicTerms(String tag) {
    final words = tag
        .replaceFirst('#', '')
        .replaceAllMapped(
          RegExp(r'([A-Z]+)([A-Z][a-z])'),
          (match) => '${match[1]} ${match[2]}',
        )
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (match) => '${match[1]} ${match[2]}',
        )
        .replaceAll(RegExp(r'\d+'), '')
        .toLowerCase()
        .split(RegExp(r'[^a-z]+'));
    return words.where((word) => word.length > 2).toList();
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
            onTap: () => widget.onOpenOfficialHandle?.call(
              handle,
              _followedHandleIds.contains(handle.id),
              () => _toggleFollow(handle.id),
            ),
          );
        },
      ),
    );
  }
}
