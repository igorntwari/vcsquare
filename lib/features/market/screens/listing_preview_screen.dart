// Step 2 of the sell flow: review the listing before publishing.
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/listing_model.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/cards/app_card.dart';
import '../../../shared/widgets/chips/status_tag.dart';
import '../../../shared/widgets/media/app_image.dart';
import '../models/listing_draft.dart';

class ListingPreviewScreen extends StatelessWidget {
  const ListingPreviewScreen({
    super.key,
    required this.draft,
    this.onBack,
    this.onPublish,
  });

  final ListingDraft draft;
  final VoidCallback? onBack;
  final VoidCallback? onPublish;

  @override
  Widget build(BuildContext context) {
    final photo = draft.photoPaths.isEmpty ? null : draft.photoPaths.first;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.topBarBackground,
        foregroundColor: AppColors.textOnDark,
        title: Text(
          AppStrings.previewListing,
          style: AppTypography.headingMedium.copyWith(
            color: AppColors.textOnDark,
          ),
        ),
        leading: IconButton(
          tooltip: AppStrings.back,
          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(AppRadius.md),
              ),
              child: photo == null
                  ? const ColoredBox(
                      color: AppColors.surfaceMuted,
                      child: Icon(
                        Icons.image_outlined,
                        color: AppColors.iconMuted,
                      ),
                    )
                  : AppImage(
                      photo,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const ColoredBox(
                        color: AppColors.surfaceMuted,
                        child: Icon(
                          Icons.image_outlined,
                          color: AppColors.iconMuted,
                        ),
                      ),
                    ),
            ),
          ),
          if (draft.photoPaths.length > 1) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              AppStrings.previewPhotoCount(draft.photoPaths.length),
              textAlign: TextAlign.end,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  draft.title,
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
            Formatters.priceRwf(draft.priceRwf),
            style: AppTypography.price.copyWith(color: AppColors.price),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              StatusTag(
                label: draft.categoryName,
                backgroundColor: AppColors.surfaceMuted,
                foregroundColor: AppColors.textSecondary,
              ),
              if (draft.pickupHubName != null)
                StatusTag(
                  label: draft.pickupHubName!,
                  backgroundColor: AppColors.surfaceMuted,
                  foregroundColor: AppColors.textSecondary,
                  icon: Icons.location_on_outlined,
                ),
              if (draft.negotiable)
                const StatusTag(
                  label: AppStrings.openToNegotiation,
                  backgroundColor: AppColors.greenSurface,
                  foregroundColor: AppColors.success,
                ),
            ],
          ),
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
                  draft.description.isEmpty
                      ? AppStrings.noListingDescription
                      : draft.description,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: PrimaryButton(
            label: AppStrings.publishListing,
            icon: Icons.check,
            onPressed: onPublish,
          ),
        ),
      ),
    );
  }

  String get _conditionLabel => switch (draft.condition) {
    ListingCondition.brandNew => AppStrings.conditionNew,
    ListingCondition.likeNew => AppStrings.conditionLikeNew,
    ListingCondition.good => AppStrings.conditionGood,
    ListingCondition.used => AppStrings.conditionUsed,
    ListingCondition.forParts => AppStrings.conditionForParts,
  };
}
