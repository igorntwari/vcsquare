// Model representing a verified official campus account.
import 'package:flutter/widgets.dart';

import '../../core/constants/app_icons.dart';
import 'firestore_helpers.dart';

class OfficialHandleModel {
  const OfficialHandleModel({
    required this.id,
    required this.name,
    required this.handle,
    required this.category,
    required this.description,
    required this.iconName,
    this.order = 0,
  });

  final String id;
  final String name;
  final String handle;

  // Department label shown as a tag, e.g. "CAREERS".
  final String category;
  final String description;

  // Key in AppIcons, e.g. "school".
  final String iconName;
  final int order;

  IconData get icon => AppIcons.named(iconName);

  // officialHandles/{id}
  factory OfficialHandleModel.fromFirestore(String id, FirestoreMap data) =>
      OfficialHandleModel(
        id: id,
        name: readString(data['name']),
        handle: readString(data['handle']),
        category: readString(data['category']),
        description: readString(data['description']),
        iconName: readString(data['iconName']),
        order: readInt(data['order']),
      );

  FirestoreMap toFirestore() => {
    'name': name,
    'handle': handle,
    'category': category,
    'description': description,
    'iconName': iconName,
    'order': order,
  };
}
