// Root app widget that wires theme and routing together.
import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      home: const Scaffold(),
    );
  }
}
