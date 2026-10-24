// Gradient background used behind screens.
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

// Full-screen navy-to-crimson onboarding background.
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.onboardingGradient),
      child: SizedBox.expand(child: child),
    );
  }
}
