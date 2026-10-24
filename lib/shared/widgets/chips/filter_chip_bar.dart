// Horizontally scrolling row of filter chips.
import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import 'app_chip.dart';

// Single-select row of chips. Pass the chips' look via [chips]; this widget
// tracks which one is selected and reports taps through [onSelected].
class FilterChipBar extends StatefulWidget {
  const FilterChipBar({
    super.key,
    required this.chips,
    this.initialIndex = 0,
    this.onSelected,
  });

  final List<AppChip> chips;
  final int initialIndex;
  final ValueChanged<int>? onSelected;

  @override
  State<FilterChipBar> createState() => _FilterChipBarState();
}

class _FilterChipBarState extends State<FilterChipBar> {
  late int _selectedIndex = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          for (var i = 0; i < widget.chips.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.xs),
            AppChip(
              label: widget.chips[i].label,
              icon: widget.chips[i].icon,
              dotColor: widget.chips[i].dotColor,
              selected: i == _selectedIndex,
              onTap: () {
                setState(() => _selectedIndex = i);
                widget.onSelected?.call(i);
              },
            ),
          ],
        ],
      ),
    );
  }
}
