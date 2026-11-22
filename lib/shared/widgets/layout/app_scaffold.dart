// Base page scaffold for screens pushed on top of the main tabs.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';

// Light background, dark status bar icons and an optional fixed header
// above a body that fills the rest of the screen.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.header,
    this.bottomBar,
    this.lightStatusBar = false,
    this.backgroundColor = AppColors.background,
  });

  final Widget body;

  // Fixed at the top; handles its own SafeArea (see SellItemScreen's header).
  final Widget? header;

  // Fixed at the bottom, e.g. a ChatInputBar or action buttons.
  final Widget? bottomBar;

  // True when [header] is dark (navy), so the status bar icons turn white.
  final bool lightStatusBar;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: lightStatusBar
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            ?header,
            Expanded(child: body),
            ?bottomBar,
          ],
        ),
      ),
    );
  }
}
