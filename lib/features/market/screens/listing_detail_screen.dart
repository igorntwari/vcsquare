// Full listing details shown after opening a marketplace card.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/listing_model.dart';
import '../../../shared/widgets/avatars/user_avatar.dart';
import '../../../shared/widgets/badges/verified_badge.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/cards/app_card.dart';
import '../../../shared/widgets/chips/status_tag.dart';
import '../../../shared/widgets/media/app_image.dart';
import '../widgets/trust_banner.dart';

class ListingDetailScreen extends StatelessWidget {
  const ListingDetailScreen({
    super.key,
    required this.listing,
    this.onMessageSeller,
  });

  final ListingModel listing;
  final VoidCallback? onMessageSeller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.topBarBackground,
        foregroundColor: AppColors.textOnDark,
        title: Text(
          AppStrings.listingDetailsTitle,
          style: AppTypography.headingMedium.copyWith(
            color: AppColors.textOnDark,
          ),
        ),
        leading: IconButton(
          tooltip: AppStrings.back,
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          _buildPhoto(),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  listing.title,
                  style: AppTypography.headingLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              StatusTag(
                label: _conditionLabel,
                backgroundColor: AppColors.chipBackground,
                foregroundColor: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            Formatters.priceRwf(listing.priceRwf),
            style: AppTypography.price.copyWith(color: AppColors.price),
          ),
          if (listing.tag != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: StatusTag(
                label: listing.tag!,
                backgroundColor: AppColors.surfaceMuted,
                foregroundColor: AppColors.textSecondary,
                icon: Icons.location_on_outlined,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.listingDetailsSection,
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  listing.details,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Row(
              children: [
                UserAvatar(
                  size: AppSizes.avatarXl,
                  imagePath: listing.seller.avatarPath,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listing.seller.name,
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        listing.seller.handle,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (listing.seller.isVerified) const VerifiedBadge(),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const TrustBanner(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: PrimaryButton(
            label: AppStrings.messageSeller,
            icon: Icons.chat_bubble_outline,
            onPressed: onMessageSeller,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoto() {
    final path = listing.imagePath;
    final placeholder = Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
      ),
      child: const Center(
        child: Icon(Icons.image_outlined, color: AppColors.iconMuted),
      ),
    );
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
        child: path == null
            ? placeholder
            : AppImage(
                path,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => placeholder,
              ),
      ),
    );
  }

  String get _conditionLabel => switch (listing.condition) {
    ListingCondition.brandNew => AppStrings.conditionNew,
    ListingCondition.likeNew => AppStrings.conditionLikeNew,
    ListingCondition.good => AppStrings.conditionGood,
    ListingCondition.used => AppStrings.conditionUsed,
    ListingCondition.forParts => AppStrings.conditionForParts,
  };
}
