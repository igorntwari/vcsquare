// Marketplace browse screen.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/optimistic_toggle.dart';
import '../../../data/models/listing_model.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../shared/widgets/buttons/floating_pill_button.dart';
import '../../../shared/widgets/chips/app_chip.dart';
import '../../../shared/widgets/chips/status_tag.dart';
import '../../../shared/widgets/feedback/empty_state.dart';
import '../../../shared/widgets/feedback/error_state.dart';
import '../../../shared/widgets/feedback/loading_indicator.dart';
import '../../../shared/widgets/inputs/app_search_bar.dart';
import '../../../shared/widgets/layout/app_top_bar.dart';
import '../providers/market_providers.dart';
import '../widgets/category_grid.dart';
import '../widgets/exchange_tip_card.dart';
import '../widgets/listing_grid.dart';
import '../widgets/sort_chips.dart';
import '../widgets/trust_banner.dart';

enum _SortOrder { latest, priceLowHigh, pickupHub }

class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key, this.onSellItem, this.onOpenListing});

  final VoidCallback? onSellItem;
  final ValueChanged<ListingModel>? onOpenListing;

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  static const int _budgetLimitRwf = 50000;

  String? _selectedCategoryId;
  bool _verifiedOnly = false;
  bool _underBudget = false;
  String _searchQuery = '';
  _SortOrder _sortOrder = _SortOrder.latest;

  // The data these local copies were made from. A refetch replaces them.
  MarketData? _data;
  Set<String> _favoriteIds = {};

  void _adopt(MarketData data) {
    if (data == _data) return;
    _data = data;
    _favoriteIds = {...data.savedListingIds};
  }

  List<ListingModel> _visibleListings(List<ListingModel> all) {
    final query = _searchQuery.trim().toLowerCase();
    final listings = all.where((listing) {
      final categoryNames =
          _data?.categories
              .where((category) => category.id == listing.categoryId)
              .map((category) => category.name) ??
          const <String>[];
      final searchableText = [
        listing.title,
        listing.details,
        listing.seller.name,
        listing.seller.handle,
        listing.tag,
        ...categoryNames,
      ].whereType<String>();
      if (query.isNotEmpty &&
          !searchableText.any((value) => value.toLowerCase().contains(query))) {
        return false;
      }
      if (_selectedCategoryId != null &&
          listing.categoryId != _selectedCategoryId) {
        return false;
      }
      if (_verifiedOnly && !listing.seller.isVerified) return false;
      if (_underBudget && listing.priceRwf >= _budgetLimitRwf) return false;
      return true;
    }).toList();

    switch (_sortOrder) {
      case _SortOrder.latest:
        listings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case _SortOrder.priceLowHigh:
        listings.sort((a, b) => a.priceRwf.compareTo(b.priceRwf));
      case _SortOrder.pickupHub:
        listings.sort((a, b) => (a.tag ?? '').compareTo(b.tag ?? ''));
    }
    return listings;
  }

  void _toggleFavorite(ListingModel listing) {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return;
    optimisticToggle(
      ids: _favoriteIds,
      id: listing.id,
      update: (change) {
        if (mounted) setState(change);
      },
      save: (saved) => ref
          .read(listingsRepositoryProvider)
          .setSaved(userId: userId, listingId: listing.id, saved: saved),
      onError: () {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text(AppStrings.saveFailed)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final market = ref.watch(marketProvider);
    if (market.value case final loaded?) _adopt(loaded);
    final data = _data;
    final listings = data == null
        ? const <ListingModel>[]
        : _visibleListings(data.listings);
    final categories = data?.categories ?? const [];
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Column(
      children: [
        AppTopBar(
          title: AppStrings.navMarket,
          avatarImagePath: user?.avatarPath,
        ),
        Expanded(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: ColoredBox(
                      color: AppColors.topBarBackground,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.sm,
                          AppSpacing.lg,
                          AppSpacing.lg,
                        ),
                        child: AppSearchBar(
                          hintText: AppStrings.marketSearchHint,
                          onChanged: (value) =>
                              setState(() => _searchQuery = value),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: _buildQuickFilters()),
                  SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    sliver: SliverList.list(
                      children: [
                        _buildCategoriesHeader(categories.length),
                        const SizedBox(height: AppSpacing.sm),
                        if (data == null)
                          market.hasError
                              ? ErrorState(
                                  onRetry: () => ref.invalidate(marketProvider),
                                )
                              : const LoadingIndicator()
                        else
                          CategoryGrid(
                            categories: categories,
                            selectedId: _selectedCategoryId,
                            onSelected: (id) =>
                                setState(() => _selectedCategoryId = id),
                          ),
                        const SizedBox(height: AppSpacing.lg),
                        const TrustBanner(),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          AppStrings.recentListings,
                          style: AppTypography.headingMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          AppStrings.recentListingsSubtitle,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        SortChips(
                          options: const [
                            AppStrings.sortLatest,
                            AppStrings.sortPriceLowHigh,
                            AppStrings.sortPickupHub,
                          ],
                          selectedIndex: _sortOrder.index,
                          onSelected: (index) => setState(
                            () => _sortOrder = _SortOrder.values[index],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    sliver: data == null
                        ? const SliverToBoxAdapter()
                        : listings.isEmpty
                        ? const SliverToBoxAdapter(
                            child: EmptyState(
                              icon: Icons.storefront_outlined,
                              title: AppStrings.noListingsTitle,
                              message: AppStrings.noListingsMessage,
                            ),
                          )
                        : ListingGrid(
                            listings: listings,
                            favoriteIds: _favoriteIds,
                            onFavorite: _toggleFavorite,
                            onOpenListing: widget.onOpenListing,
                          ),
                  ),
                  SliverPadding(
                    // Leaves room for the floating Sell button and nav bar.
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      bottomInset + AppSpacing.xxxl + AppSpacing.xxl,
                    ),
                    sliver: const SliverToBoxAdapter(child: ExchangeTipCard()),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: bottomInset + AppSpacing.lg,
                child: Center(
                  child: FloatingPillButton(
                    icon: Icons.photo_camera_outlined,
                    label: AppStrings.sellAnItem,
                    onPressed: widget.onSellItem,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        0,
      ),
      child: Row(
        children: [
          const StatusTag(
            label: AppStrings.marketLocation,
            icon: Icons.location_on,
            backgroundColor: AppColors.locationPillBackground,
            foregroundColor: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.sm),
          AppChip(
            label: AppStrings.verifiedStudentSellers,
            trailingIcon: Icons.check_circle,
            trailingIconColor: AppColors.success,
            selected: _verifiedOnly,
            onTap: () => setState(() => _verifiedOnly = !_verifiedOnly),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppChip(
            label: AppStrings.underBudget,
            selected: _underBudget,
            onTap: () => setState(() => _underBudget = !_underBudget),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesHeader(int categoryCount) {
    return Row(
      children: [
        Expanded(
          child: Text(
            AppStrings.browseCategories,
            style: AppTypography.overline.copyWith(color: AppColors.textMuted),
          ),
        ),
        Text(
          AppStrings.categoriesCount(categoryCount),
          style: AppTypography.buttonSmall.copyWith(color: AppColors.accent),
        ),
      ],
    );
  }
}
