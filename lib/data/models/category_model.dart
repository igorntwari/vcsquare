// Model representing a marketplace category.
import 'package:flutter/widgets.dart';

import '../../core/constants/app_icons.dart';
import 'firestore_helpers.dart';

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
    this.order = 0,
  });

  final String id;
  final String name;

  // Key in AppIcons, e.g. "laptop".
  final String iconName;

  // Position in the category grid, lowest first.
  final int order;

  IconData get icon => AppIcons.named(iconName);

  // categories/{id}
  factory CategoryModel.fromFirestore(String id, FirestoreMap data) =>
      CategoryModel(
        id: id,
        name: readString(data['name']),
        iconName: readString(data['iconName']),
        order: readInt(data['order']),
      );

  FirestoreMap toFirestore() => {
    'name': name,
    'iconName': iconName,
    'order': order,
  };
}
