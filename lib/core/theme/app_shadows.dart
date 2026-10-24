// Shadow and elevation tokens.
import 'package:flutter/painting.dart';

import 'app_colors.dart';

abstract final class AppShadows {
  // Subtle lift under white cards.
  static const List<BoxShadow> card = [
    BoxShadow(color: AppColors.shadow, offset: Offset(0, 1), blurRadius: 1),
  ];

  // Soft shadow cast upward by the bottom navigation bar.
  static const List<BoxShadow> navBar = [
    BoxShadow(
      color: AppColors.navyShadowSoft,
      offset: Offset(0, -4),
      blurRadius: 16,
    ),
  ];

  // Red glow under the active nav circle and red floating buttons.
  static const List<BoxShadow> accentGlow = [
    BoxShadow(color: AppColors.redGlow, offset: Offset(0, 8), blurRadius: 12),
  ];
}
