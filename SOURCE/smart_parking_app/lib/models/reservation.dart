class Reservation {
  final int id;
  final int parkingSlotId;
  final String status;
  final String reservationTime;

  Reservation({
    required this.id,
    required this.parkingSlotId,
    required this.status,
    required this.reservationTime,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      parkingSlotId: json['parkingSlotId'],
      status: json['status'],
      reservationTime: json['reservationTime'],
    );
  }
}
