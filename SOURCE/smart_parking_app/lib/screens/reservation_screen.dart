import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ReservationScreen extends StatefulWidget {
  final ApiService apiService;
  const ReservationScreen({super.key, required this.apiService});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đặt chỗ của tôi")),
      body: FutureBuilder(
        future: widget.apiService.getMyReservations(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final reservations = snapshot.data!;
            return ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final r = reservations[index];
                return ListTile(
                  title: Text("Slot ID: ${r.parkingSlotId}"),
                  subtitle: Text("Thời gian: ${r.reservationTime}"),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      final ok =
                          await widget.apiService.cancelReservation(r.id);
                      if (ok) setState(() {});
                    },
                    child: const Text("Hủy"),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("Lỗi tải dữ liệu"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
