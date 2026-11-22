// Bottom sheet with an event's date, venue and price, and an RSVP button.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/event_model.dart';

// Pops true when the RSVP button is tapped, so the caller can toggle it.
class EventDetailsSheet extends StatelessWidget {
  const EventDetailsSheet({
    super.key,
    required this.event,
    required this.isRsvped,
  });

  final EventModel event;
  final bool isRsvped;

  @override
  Widget build(BuildContext context) {
    final when =
        '${Formatters.monthShort(event.startsAt)} ${event.startsAt.day}, '
        '${Formatters.time24(event.startsAt)} ${AppStrings.timezone}';
    final price = event.isFree
        ? AppStrings.freeEntry
        : Formatters.priceRwf(event.priceRwf!);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (event.label != null) ...[
              Text(
                event.label!,
                style: AppTypography.label.copyWith(color: AppColors.accent),
              ),
              const SizedBox(height: AppSpacing.xs),
            ],
            Text(
              event.title,
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildRow(Icons.schedule, when),
            _buildRow(Icons.place_outlined, event.venue),
            _buildRow(Icons.confirmation_number_outlined, price),
            if (event.note != null) _buildRow(Icons.info_outline, event.note!),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              icon: Icon(isRsvped ? Icons.check : Icons.event_available),
              label: Text(
                isRsvped ? AppStrings.cancelRsvp : AppStrings.rsvpNow,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: AppSizes.iconSm, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
