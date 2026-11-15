// Icons that data can refer to by name (categories, official accounts,
// pickup hubs). The database stores the name; the app looks it up here.
import 'package:flutter/material.dart';

abstract final class AppIcons {
  // Keys match the Flutter `Icons.` constant names, so the database stays
  // readable. Add an entry here before using a new name in Firestore.
  static const Map<String, IconData> _byName = {
    // Marketplace categories
    'laptop': Icons.laptop,
    'chair_outlined': Icons.chair_outlined,
    'microwave_outlined': Icons.microwave_outlined,
    'menu_book_outlined': Icons.menu_book_outlined,
    'checkroom_outlined': Icons.checkroom_outlined,
    'home_work_outlined': Icons.home_work_outlined,
    'handyman_outlined': Icons.handyman_outlined,
    'grid_view': Icons.grid_view,
    // Official accounts
    'school': Icons.school,
    'diversity_3': Icons.diversity_3,
    'work_outline': Icons.work_outline,
    'sports_soccer': Icons.sports_soccer,
    // Pickup hubs
    'security_outlined': Icons.security_outlined,
    'local_library_outlined': Icons.local_library_outlined,
    'apartment_outlined': Icons.apartment_outlined,
  };

  static const IconData fallback = Icons.category_outlined;

  static IconData named(String name) => _byName[name] ?? fallback;

  static bool isKnown(String name) => _byName.containsKey(name);
}
