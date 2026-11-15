// Placeholder campus pickup hubs before real data.
import '../models/pickup_hub_model.dart';

const List<PickupHubModel> dummyPickupHubs = [
  PickupHubModel(
    id: 'hub_atrium',
    name: 'Innovation Hub Atrium',
    description: 'High-footfall central zone with security desk',
    iconName: 'security_outlined',
    order: 0,
  ),
  PickupHubModel(
    id: 'hub_library',
    name: 'ALU Library Foyer',
    description: 'Quiet study wing meeting corner',
    iconName: 'local_library_outlined',
    order: 1,
  ),
  PickupHubModel(
    id: 'hub_hostel_b',
    name: 'Hostel Block B Entrance',
    description: 'Residential area pickup bench',
    iconName: 'apartment_outlined',
    order: 2,
  ),
];
