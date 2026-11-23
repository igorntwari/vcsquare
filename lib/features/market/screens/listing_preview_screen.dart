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

class ListingPreviewScreen extends StatefulWidget {
  const ListingPreviewScreen({
    super.key,
    required this.draft,
    this.isEditing = false,
    this.onBack,
    this.onPublish,
  });

  final ListingDraft draft;
  final bool isEditing;
  final VoidCallback? onBack;
  final Future<void> Function()? onPublish;

  @override
  State<ListingPreviewScreen> createState() => _ListingPreviewScreenState();
}

class _ListingPreviewScreenState extends State<ListingPreviewScreen> {
  bool _isPublishing = false;

  Future<void> _publish() async {
    final onPublish = widget.onPublish;
    if (onPublish == null || _isPublishing) return;
    setState(() => _isPublishing = true);
    try {
      await onPublish();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text(AppStrings.saveFailed)));
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    final photos = draft.photoUrls;
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
          onPressed: widget.onBack ?? () => Navigator.of(context).maybePop(),
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
              child: photos.isEmpty
                  ? const ColoredBox(
                      color: AppColors.surfaceMuted,
                      child: Icon(
                        Icons.image_outlined,
                        color: AppColors.iconMuted,
                      ),
                    )
                  : PageView.builder(
                      itemCount: photos.length,
                      itemBuilder: (context, index) => AppImage(
                        photos[index],
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
          ),
          if (draft.photoUrls.length > 1) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              AppStrings.previewPhotoCount(draft.photoUrls.length),
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
            label: widget.isEditing
                ? AppStrings.saveChanges
                : AppStrings.publishListing,
            icon: Icons.check,
            onPressed: _isPublishing ? null : _publish,
          ),
        ),
      ),
    );
  }

  String get _conditionLabel => switch (widget.draft.condition) {
    ListingCondition.brandNew => AppStrings.conditionNew,
    ListingCondition.likeNew => AppStrings.conditionLikeNew,
    ListingCondition.good => AppStrings.conditionGood,
    ListingCondition.used => AppStrings.conditionUsed,
    ListingCondition.forParts => AppStrings.conditionForParts,
  };
}
