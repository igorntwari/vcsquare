// Selector for the campus pickup hub.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/pickup_hub_model.dart';

// Stacked options; the selected hub shows a navy check, others a white dot.
class PickupHubSelector extends StatelessWidget {
  const PickupHubSelector({
    super.key,
    required this.hubs,
    this.selectedId,
    this.onSelected,
  });

  final List<PickupHubModel> hubs;
  final String? selectedId;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < hubs.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.sm),
          _buildOption(hubs[i]),
        ],
      ],
    );
  }

  Widget _buildOption(PickupHubModel hub) {
    final isSelected = hub.id == selectedId;

    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: AppColors.formOptionBackground,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => onSelected?.call(hub.id),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(hub.icon, size: AppSizes.iconSm, color: AppColors.iconDefault),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hub.name,
                        style: (isSelected
                                ? AppTypography.titleMedium
                                : AppTypography.bodyLarge)
                            .copyWith(color: AppColors.textPrimary),
                      ),
                      Text(
                        hub.description,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textOnTint,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  width: AppSizes.radioSize,
                  height: AppSizes.radioSize,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: AppSizes.iconXs,
                          color: AppColors.textOnDark,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
