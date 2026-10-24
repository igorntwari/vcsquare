// Card showing a listing summary.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/listing_model.dart';
import '../../../shared/widgets/avatars/user_avatar.dart';
import '../../../shared/widgets/chips/status_tag.dart';

// Photo with a pickup tag and favourite button, then price, condition,
// title, details and seller.
class ListingCard extends StatelessWidget {
  const ListingCard({
    super.key,
    required this.listing,
    this.isFavorite = false,
    this.onFavorite,
    this.onTap,
  });

  final ListingModel listing;
  final bool isFavorite;
  final VoidCallback? onFavorite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        boxShadow: AppShadows.card,
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: AppSizes.listingImageHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildPhoto(),
                    if (listing.tag != null)
                      Positioned(
                        top: AppSpacing.sm,
                        left: AppSpacing.sm,
                        right: AppSizes.iconButtonSm + AppSpacing.md,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _buildTag(),
                        ),
                      ),
                    Positioned(
                      top: AppSpacing.sm,
                      right: AppSpacing.sm,
                      child: _buildFavoriteButton(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            // Shrinks long prices ("RWF 750,000") to one line.
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                Formatters.priceRwf(listing.priceRwf),
                                style: AppTypography.price.copyWith(
                                  color: AppColors.price,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          _buildConditionTag(),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        listing.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        listing.details,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          UserAvatar(
                            size: AppSizes.avatarXxxs,
                            imagePath: listing.seller.avatarPath,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              listing.seller.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.captionStrong.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Text(
                            Formatters.timeAgo(listing.createdAt),
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoto() {
    const placeholder = ColoredBox(
      color: AppColors.surfaceMuted,
      child: Icon(
        Icons.image_outlined,
        size: AppSizes.iconLg,
        color: AppColors.iconMuted,
      ),
    );
    if (listing.imagePath == null) return placeholder;
    return Image.asset(
      listing.imagePath!,
      fit: BoxFit.cover,
      // Placeholder until the photo is added to assets/images/listings.
      errorBuilder: (_, _, _) => placeholder,
    );
  }

  Widget _buildTag() {
    final (background, foreground) = switch (listing.tagStyle) {
      ListingTagStyle.dark => (AppColors.listingTagDark, AppColors.textOnDark),
      ListingTagStyle.accent => (AppColors.accent, AppColors.textOnDark),
      ListingTagStyle.light => (
        AppColors.listingTagLight,
        AppColors.textPrimary,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.pill)),
      ),
      child: Text(
        listing.tag!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.captionStrong.copyWith(color: foreground),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Semantics(
      button: true,
      toggled: isFavorite,
      label: AppStrings.favorite,
      child: Material(
        color: AppColors.favoriteButtonBackground,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onFavorite,
          child: SizedBox.square(
            dimension: AppSizes.iconButtonSm,
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              size: AppSizes.iconSm,
              color: isFavorite ? AppColors.likeActive : AppColors.iconDefault,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConditionTag() {
    final (label, background, foreground) = switch (listing.condition) {
      ListingCondition.brandNew => (
        AppStrings.conditionNew,
        AppColors.greenSurface,
        AppColors.success,
      ),
      ListingCondition.likeNew => (
        AppStrings.conditionLikeNew,
        AppColors.greenSurface,
        AppColors.success,
      ),
      ListingCondition.good => (
        AppStrings.conditionGood,
        AppColors.chipBackground,
        AppColors.textSecondary,
      ),
      ListingCondition.used => (
        AppStrings.conditionUsed,
        AppColors.surfaceMuted,
        AppColors.textSecondary,
      ),
      ListingCondition.forParts => (
        AppStrings.conditionForParts,
        AppColors.redSurface,
        AppColors.accent,
      ),
    };
    return StatusTag(
      label: label,
      backgroundColor: background,
      foregroundColor: foreground,
    );
  }
}
