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
    this.tabRequests,
  });

  final List<Widget> tabs;
  final int messagesBadgeCount;

  // Tab requests from outside, e.g. a tapped push. Cleared once handled.
  final ValueNotifier<int?>? tabRequests;

  // Switches to [index] from anywhere inside the shell, e.g. the top bar
  // avatar opening Profile. Does nothing outside the shell.
  static void selectTab(BuildContext context, int index) =>
      context.findAncestorStateOfType<_MainShellState>()?._select(index);

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.tabRequests?.addListener(_onTabRequest);
    _onTabRequest();
  }

  @override
  void didUpdateWidget(MainShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabRequests != widget.tabRequests) {
      oldWidget.tabRequests?.removeListener(_onTabRequest);
      widget.tabRequests?.addListener(_onTabRequest);
    }
  }

  @override
  void dispose() {
    widget.tabRequests?.removeListener(_onTabRequest);
    super.dispose();
  }

  void _onTabRequest() {
    final requests = widget.tabRequests;
    final index = requests?.value;
    if (requests == null || index == null) return;
    requests.value = null;
    if (index < 0 || index >= widget.tabs.length) return;
    _currentIndex = index;
    if (mounted) setState(() {});
  }

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
