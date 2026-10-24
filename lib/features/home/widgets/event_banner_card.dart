// Banner card promoting a campus event.
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/event_model.dart';
import '../../../shared/widgets/chips/status_tag.dart';

// Navy flyer with glowing corners, a date box and a free or price badge.
class EventBannerCard extends StatelessWidget {
  const EventBannerCard({super.key, required this.event});

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.sm)),
      child: Container(
        color: AppColors.eventBannerBackground,
        constraints: const BoxConstraints(
          minHeight: AppSizes.eventBannerMinHeight,
        ),
        child: Stack(
          children: [
            Positioned(
              top: -AppSpacing.xxl,
              right: -AppSpacing.xxl,
              child: _buildFlare(AppColors.eventFlareWarm),
            ),
            Positioned(
              bottom: -AppSpacing.xxl,
              left: -AppSpacing.xxl,
              child: _buildFlare(AppColors.eventFlareCool),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (event.label != null)
                              Text(
                                event.label!,
                                style: AppTypography.overline.copyWith(
                                  color: AppColors.eventHighlight,
                                ),
                              ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              event.title,
                              style: AppTypography.displayLarge.copyWith(
                                color: AppColors.textOnDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      _buildDateBox(),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: AppSizes.iconSm,
                        color: AppColors.textOnDarkSoft,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          '${event.venue} ${AppStrings.bulletSeparator} '
                          '${Formatters.time24(event.startsAt)} '
                          '${AppStrings.timezone}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textOnDarkSoft,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      event.isFree
                          ? const StatusTag(
                              label: AppStrings.freeEntry,
                              backgroundColor: AppColors.freeEntryBackground,
                              foregroundColor: AppColors.textOnDark,
                            )
                          : StatusTag(
                              label: Formatters.priceRwf(event.priceRwf!),
                              icon: Icons.confirmation_number_outlined,
                              backgroundColor: AppColors.priceTagBackground,
                              foregroundColor: AppColors.textPrimary,
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateBox() {
    return Container(
      constraints: const BoxConstraints(minWidth: AppSizes.eventDateMinWidth),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: const BoxDecoration(
        color: AppColors.eventDateBackground,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
      ),
      child: Column(
        children: [
          Text(
            Formatters.monthShort(event.startsAt).toUpperCase(),
            style: AppTypography.overline.copyWith(
              color: AppColors.eventHighlight,
            ),
          ),
          Text(
            '${event.startsAt.day}',
            style: AppTypography.headingLarge.copyWith(
              color: AppColors.textOnDark,
            ),
          ),
        ],
      ),
    );
  }

  // Soft blurred circle bleeding off a corner of the flyer.
  Widget _buildFlare(Color color) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        width: AppSizes.eventFlare,
        height: AppSizes.eventFlare,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
