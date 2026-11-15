// Model representing a designated safe exchange spot on campus.
import 'package:flutter/widgets.dart';

import '../../core/constants/app_icons.dart';
import 'firestore_helpers.dart';

class PickupHubModel {
  const PickupHubModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    this.order = 0,
  });

  final String id;
  final String name;
  final String description;

  // Key in AppIcons, e.g. "security_outlined".
  final String iconName;
  final int order;

  IconData get icon => AppIcons.named(iconName);

  // pickupHubs/{id}
  factory PickupHubModel.fromFirestore(String id, FirestoreMap data) =>
      PickupHubModel(
        id: id,
        name: readString(data['name']),
        description: readString(data['description']),
        iconName: readString(data['iconName']),
        order: readInt(data['order']),
      );

  FirestoreMap toFirestore() => {
    'name': name,
    'description': description,
    'iconName': iconName,
    'order': order,
  };
}
