class ParkingSlot {
  final int id;
  final String slotCode;
  final bool isOccupied;
  final int parkingLotId;

  ParkingSlot({
    required this.id,
    required this.slotCode,
    required this.isOccupied,
    required this.parkingLotId,
  });

  factory ParkingSlot.fromJson(Map<String, dynamic> json) {
    return ParkingSlot(
      id: json['id'],
      slotCode: json['slotCode'],
      isOccupied: json['isOccupied'],
      parkingLotId: json['parkingLotId'],
    );
  }
}
