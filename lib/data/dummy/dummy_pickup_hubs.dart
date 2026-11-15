// Placeholder campus pickup hubs before real data.
import 'package:flutter/material.dart';

import '../models/pickup_hub_model.dart';

const List<PickupHubModel> dummyPickupHubs = [
  PickupHubModel(
    id: 'hub_atrium',
    name: 'Innovation Hub Atrium',
    description: 'High-footfall central zone with security desk',
    icon: Icons.security_outlined,
  ),
  PickupHubModel(
    id: 'hub_library',
    name: 'ALU Library Foyer',
    description: 'Quiet study wing meeting corner',
    icon: Icons.local_library_outlined,
  ),
  PickupHubModel(
    id: 'hub_hostel_b',
    name: 'Hostel Block B Entrance',
    description: 'Residential area pickup bench',
    icon: Icons.apartment_outlined,
  ),
];
