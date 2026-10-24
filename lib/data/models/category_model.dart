// Model representing a marketplace category.
import 'package:flutter/widgets.dart';

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;
  final IconData icon;
}
