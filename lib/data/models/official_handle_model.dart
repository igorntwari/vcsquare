// Model representing a verified official campus account.
import 'package:flutter/widgets.dart';

class OfficialHandleModel {
  const OfficialHandleModel({
    required this.id,
    required this.name,
    required this.handle,
    required this.category,
    required this.description,
    required this.icon,
    this.isFollowing = false,
  });

  final String id;
  final String name;
  final String handle;

  // Department label shown as a tag, e.g. "CAREERS".
  final String category;
  final String description;
  final IconData icon;

  // Whether the current user already followed it when Explore loaded.
  final bool isFollowing;
}
