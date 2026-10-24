// Shadow and elevation tokens.
import 'package:flutter/painting.dart';

import 'app_colors.dart';

abstract final class AppShadows {
  // Subtle lift under white cards.
  static const List<BoxShadow> card = [
    BoxShadow(color: AppColors.shadow, offset: Offset(0, 1), blurRadius: 1),
  ];
}
