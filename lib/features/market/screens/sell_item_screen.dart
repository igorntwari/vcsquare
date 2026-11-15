// Form screen for creating a new listing.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/dummy/dummy_categories.dart';
import '../../../data/dummy/dummy_listings.dart';
import '../../../data/dummy/dummy_pickup_hubs.dart';
import '../../../data/models/listing_model.dart';
import '../../../shared/widgets/cards/app_card.dart';
import '../../../shared/widgets/chips/app_chip.dart';
import '../../../shared/widgets/chips/status_tag.dart';
import '../../../shared/widgets/inputs/app_text_area.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../shared/widgets/inputs/app_toggle_row.dart';
import '../widgets/condition_selector.dart';
import '../widgets/photo_upload_section.dart';
import '../widgets/pickup_hub_selector.dart';
import '../widgets/price_input.dart';

// Step 1 of 2: photos, title, category, condition, price, pickup hub and
// description. The completion percentage updates as fields are filled.
class SellItemScreen extends StatefulWidget {
  const SellItemScreen({super.key, this.onClose, this.onPreview});

  final VoidCallback? onClose;
  final VoidCallback? onPreview;

  @override
  State<SellItemScreen> createState() => _SellItemScreenState();
}

class _SellItemScreenState extends State<SellItemScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _photos = [];
  String? _categoryId;
  ListingCondition? _condition;
  String? _hubId;
  bool _negotiable = true;
  int _draftCount = 1;

  static const List<String> _quickAdds = [
    AppStrings.quickAddOriginalBox,
    AppStrings.quickAddWarranty,
    AppStrings.quickAddMovingOut,
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _hasPrice => (int.tryParse(_priceController.text) ?? 0) > 0;

  bool get _readyToPreview =>
      _titleController.text.trim().isNotEmpty &&
      _categoryId != null &&
      _condition != null &&
      _hasPrice;

  int get _percentComplete {
    final steps = [
      _photos.isNotEmpty,
      _titleController.text.trim().isNotEmpty,
      _categoryId != null,
      _condition != null,
      _hasPrice,
      _hubId != null,
      _descriptionController.text.trim().isNotEmpty,
    ];
    return (steps.where((done) => done).length * 100 / steps.length).round();
  }

  void _addSamplePhoto() {
    if (_photos.length >= AppSizes.maxListingPhotos) return;
    setState(() {
      _photos.add(
        dummySellPhotoSamples[_photos.length % dummySellPhotoSamples.length],
      );
    });
  }

  void _appendToDescription(String text) {
    final current = _descriptionController.text.trimRight();
    final next = current.isEmpty ? text : '$current\n• $text';
    _descriptionController.text = current.isEmpty ? '• $text' : next;
    setState(() {});
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _saveDraft() {
    setState(() => _draftCount++);
    _showMessage(AppStrings.draftSaved);
  }

  void _preview() {
    if (!_readyToPreview) {
      _showMessage(AppStrings.completeToPreview);
      return;
    }
    widget.onPreview?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  _buildProgress(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildPhotosSection(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSpecificsSection(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildPriceCard(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildPickupCard(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildDescriptionSection(),
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.frostedSurface,
        boxShadow: AppShadows.card,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              IconButton(
                tooltip: AppStrings.close,
                onPressed:
                    widget.onClose ?? () => Navigator.of(context).maybePop(),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.chipBackground,
                  fixedSize: const Size.square(AppSizes.iconCircleMd),
                ),
                icon: const Icon(
                  Icons.close,
                  size: AppSizes.iconSm,
                  color: AppColors.iconDefault,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.sellAnItem,
                      style: AppTypography.headingMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      AppStrings.sellSubtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: AppColors.chipBackground,
                shape: const StadiumBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: AppSizes.iconSm,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          AppStrings.drafts,
                          style: AppTypography.label.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        StatusTag(
                          label: '$_draftCount',
                          backgroundColor: AppColors.orangeSurface,
                          foregroundColor: AppColors.orangeDeep,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgress() {
    return Column(
      children: [
        Row(
          children: [
            const StatusTag(
              label: AppStrings.stepOneOfTwo,
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnDark,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                AppStrings.photosAndDetails,
                style: AppTypography.label.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              AppStrings.percentComplete(_percentComplete),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.pill)),
          child: SizedBox(
            height: AppSizes.progressTrack,
            child: Row(
              children: [
                Expanded(
                  child: ColoredBox(
                    color: AppColors.chipBackground,
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _percentComplete / 100,
                      child: const ColoredBox(color: AppColors.accent),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                const Expanded(
                  child: ColoredBox(color: AppColors.blueSurface),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, String hint, {Widget? trailing}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.headingMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                hint,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }

  Widget _buildFieldLabel(String label, {String? counter}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.label.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          if (counter != null)
            Text(
              counter,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPhotosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle(
          AppStrings.visualProof,
          AppStrings.visualProofHint,
          trailing: StatusTag(
            label: AppStrings.photosAdded(
              _photos.length,
              AppSizes.maxListingPhotos,
            ),
            backgroundColor: AppColors.chipBackground,
            foregroundColor: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        PhotoUploadSection(
          photos: _photos,
          onAdd: _addSamplePhoto,
          onRemove: (index) => setState(() => _photos.removeAt(index)),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: const BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          ),
          child: Row(
            children: [
              Container(
                width: AppSizes.iconButtonSm,
                height: AppSizes.iconButtonSm,
                decoration: const BoxDecoration(
                  color: AppColors.greenSurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.photo_camera_outlined,
                  size: AppSizes.iconSm,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      TextSpan(
                        text: AppStrings.proTipLead,
                        style: AppTypography.label.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const TextSpan(text: AppStrings.proTipBody),
                      TextSpan(
                        text: AppStrings.proTipHighlight,
                        style: AppTypography.label.copyWith(
                          color: AppColors.accent,
                        ),
                      ),
                      const TextSpan(text: AppStrings.proTipEnd),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecificsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle(
          AppStrings.itemSpecifics,
          AppStrings.itemSpecificsHint,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildFieldLabel(
          AppStrings.listingTitle,
          counter: AppStrings.characterCount(
            _titleController.text.length,
            AppSizes.listingTitleMaxLength,
          ),
        ),
        AppTextField(
          controller: _titleController,
          hintText: AppStrings.listingTitleHint,
          icon: Icons.sell_outlined,
          maxLength: AppSizes.listingTitleMaxLength,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildFieldLabel(AppStrings.category),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              for (final category in dummyCategories) ...[
                AppChip(
                  label: category.name,
                  icon: category.icon,
                  selected: category.id == _categoryId,
                  onTap: () => setState(() => _categoryId = category.id),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildFieldLabel(AppStrings.condition),
        ConditionSelector(
          selected: _condition,
          onSelected: (condition) => setState(() => _condition = condition),
        ),
      ],
    );
  }

  Widget _buildPriceCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFieldLabel(AppStrings.askingPrice),
          PriceInput(
            controller: _priceController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.sm),
          AppToggleRow(
            icon: Icons.handshake_outlined,
            title: AppStrings.openToNegotiation,
            subtitle: AppStrings.openToNegotiationHint,
            value: _negotiable,
            onChanged: (value) => setState(() => _negotiable = value),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: AppSizes.iconButtonSm,
                height: AppSizes.iconButtonSm,
                decoration: const BoxDecoration(
                  color: AppColors.greenSurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_outlined,
                  size: AppSizes.iconSm,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildSectionTitle(
                  AppStrings.campusPickupHub,
                  AppStrings.campusPickupHubHint,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          PickupHubSelector(
            hubs: dummyPickupHubs,
            selectedId: _hubId,
            onSelected: (id) => setState(() => _hubId = id),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: const BoxDecoration(
              color: AppColors.formOptionBackground,
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: AppSizes.iconSm,
                  color: AppColors.textOnTint,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    AppStrings.pickupTrustNote,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textOnTint,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppStrings.descriptionTitle,
                style: AppTypography.headingMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              AppStrings.characterCount(
                _descriptionController.text.length,
                AppSizes.descriptionMaxLength,
              ),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTextArea(
          controller: _descriptionController,
          hintText: AppStrings.descriptionHint,
          maxLength: AppSizes.descriptionMaxLength,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              AppStrings.quickAdd,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            for (final text in _quickAdds)
              Material(
                color: AppColors.navyTint,
                shape: const StadiumBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _appendToDescription(text),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    child: Text(
                      '+ $text',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.frostedSurface,
        boxShadow: AppShadows.navBar,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              SizedBox(
                height: AppSizes.bottomActionHeight,
                child: Material(
                  color: AppColors.chipBackground,
                  shape: const StadiumBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: _saveDraft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.save_outlined,
                            size: AppSizes.iconSm,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            AppStrings.saveDraft,
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: SizedBox(
                  height: AppSizes.bottomActionHeight,
                  child: Material(
                    color: AppColors.primary,
                    shape: const StadiumBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: _preview,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.previewListing,
                            style: AppTypography.button.copyWith(
                              color: AppColors.textOnDark,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          const Icon(
                            Icons.arrow_forward,
                            size: AppSizes.iconSm,
                            color: AppColors.textOnDark,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
