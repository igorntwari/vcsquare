// Marketplace browse screen.
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/dummy/dummy_categories.dart';
import '../../../data/dummy/dummy_listings.dart';
import '../../../data/dummy/dummy_users.dart';
import '../../../data/models/listing_model.dart';
import '../../../shared/widgets/chips/app_chip.dart';
import '../../../shared/widgets/chips/status_tag.dart';
import '../../../shared/widgets/feedback/empty_state.dart';
import '../../../shared/widgets/inputs/app_search_bar.dart';
import '../../../shared/widgets/layout/app_top_bar.dart';
import '../widgets/category_grid.dart';
import '../widgets/exchange_tip_card.dart';
import '../widgets/listing_grid.dart';
import '../widgets/sell_item_button.dart';
import '../widgets/sort_chips.dart';
import '../widgets/trust_banner.dart';

enum _SortOrder { latest, priceLowHigh, distance }

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key, this.onSellItem});

  final VoidCallback? onSellItem;

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  static const int _budgetLimitRwf = 50000;

  String? _selectedCategoryId;
  bool _verifiedOnly = false;
  bool _underBudget = false;
  _SortOrder _sortOrder = _SortOrder.latest;

  late final Set<String> _favoriteIds = {
    for (final listing in dummyListings)
      if (listing.isFavorited) listing.id,
  };

  List<ListingModel> get _visibleListings {
    final listings = dummyListings.where((listing) {
      if (_selectedCategoryId != null &&
          listing.categoryId != _selectedCategoryId) {
        return false;
      }
      if (_verifiedOnly && !listing.seller.isStudent) return false;
      if (_underBudget && listing.priceRwf >= _budgetLimitRwf) return false;
      return true;
    }).toList();

    switch (_sortOrder) {
      case _SortOrder.latest:
        listings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case _SortOrder.priceLowHigh:
        listings.sort((a, b) => a.priceRwf.compareTo(b.priceRwf));
      case _SortOrder.distance:
        listings.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }
    return listings;
  }

  void _toggleFavorite(ListingModel listing) {
    setState(() {
      if (!_favoriteIds.remove(listing.id)) _favoriteIds.add(listing.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final listings = _visibleListings;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Column(
      children: [
        AppTopBar(
          title: AppStrings.navMarket,
          avatarImagePath: dummyCurrentUser.avatarPath,
          hasUnreadNotifications: true,
        ),
        Expanded(
          child: Stack(
            children: [
              CustomScrollView(
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
                        child: AppSearchBar(
                          hintText: AppStrings.marketSearchHint,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: _buildQuickFilters()),
                  SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    sliver: SliverList.list(
                      children: [
                        _buildCategoriesHeader(),
                        const SizedBox(height: AppSpacing.sm),
                        CategoryGrid(
                          categories: dummyCategories,
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
                            AppStrings.sortDistance,
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
                    sliver: listings.isEmpty
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
                  child: SellItemButton(onPressed: widget.onSellItem),
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

  Widget _buildCategoriesHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            AppStrings.browseCategories,
            style: AppTypography.overline.copyWith(color: AppColors.textMuted),
          ),
        ),
        Text(
          AppStrings.categoriesCount(dummyCategories.length),
          style: AppTypography.buttonSmall.copyWith(color: AppColors.accent),
        ),
      ],
    );
  }
}
