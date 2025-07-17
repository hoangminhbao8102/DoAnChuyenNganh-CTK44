import 'package:smart_parking_app/models/parking_slot.dart';

class ParkingLot {
  final int id;
  final String name;
  final String address;
  final int totalSlots;
  final int availableSlots;
  final List<ParkingSlot> parkingSlots;

  ParkingLot({
    required this.id,
    required this.name,
    required this.address,
    required this.totalSlots,
    required this.availableSlots,
    required this.parkingSlots,
  });

  factory ParkingLot.fromJson(Map<String, dynamic> json) {
    var slotList = (json['parkingSlots'] as List)
        .map((e) => ParkingSlot.fromJson(e))
        .toList();

    return ParkingLot(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      totalSlots: json['totalSlots'],
      availableSlots: json['availableSlots'],
      parkingSlots: slotList,
    );
  }
}
