import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/parking_lot.dart';

class ParkingLotScreen extends StatefulWidget {
  final ApiService apiService;

  const ParkingLotScreen({Key? key, required this.apiService})
      : super(key: key);

  @override
  State<ParkingLotScreen> createState() => _ParkingLotScreenState();
}

class _ParkingLotScreenState extends State<ParkingLotScreen> {
  late Future<List<ParkingLot>> _lotsFuture;

  @override
  void initState() {
    super.initState();
    _lotsFuture = widget.apiService.getParkingLots();
  }

  void _reserveSlot(int slotId) async {
    final success = await widget.apiService.reserveSlot(slotId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Đặt chỗ thành công" : "Thất bại"),
      ),
    );
    setState(() {
      _lotsFuture = widget.apiService.getParkingLots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bãi đậu xe thông minh")),
      body: FutureBuilder<List<ParkingLot>>(
        future: _lotsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final lots = snapshot.data!;
            return ListView.builder(
              itemCount: lots.length,
              itemBuilder: (context, index) {
                final lot = lots[index];
                return ExpansionTile(
                  title: Text(
                      "${lot.name} (${lot.availableSlots}/${lot.totalSlots})"),
                  subtitle: Text(lot.address),
                  children: (lot.parkingSlots).map((slot) {
                    return ListTile(
                      title: Text("Slot: ${slot.slotCode}"),
                      trailing: slot.isOccupied
                          ? const Text("Đã đặt",
                              style: TextStyle(color: Colors.red))
                          : ElevatedButton(
                              onPressed: () => _reserveSlot(slot.id),
                              child: const Text("Đặt chỗ"),
                            ),
                    );
                  }).toList(),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
