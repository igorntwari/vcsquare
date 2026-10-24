// Model representing a designated safe exchange spot on campus.
import 'package:flutter/widgets.dart';

class PickupHubModel {
  const PickupHubModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });

  final String id;
  final String name;
  final String description;
  final IconData icon;
}
