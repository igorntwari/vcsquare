// Shell that hosts the main tabs and the bottom nav bar.
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'bottom_nav_bar.dart';

// Keeps each tab alive while switching. Tabs are passed in by the router so
// this shared widget never imports a feature.
class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.tabs,
    this.messagesBadgeCount = 0,
  });

  final List<Widget> tabs;
  final int messagesBadgeCount;

  // Switches to [index] from anywhere inside the shell, e.g. the top bar
  // avatar opening Profile. Does nothing outside the shell.
  static void selectTab(BuildContext context, int index) =>
      context.findAncestorStateOfType<_MainShellState>()?._select(index);

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _select(int index) {
    if (index < 0 || index >= widget.tabs.length) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: widget.tabs),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        messagesBadgeCount: widget.messagesBadgeCount,
        onTap: _select,
      ),
    );
  }
}
