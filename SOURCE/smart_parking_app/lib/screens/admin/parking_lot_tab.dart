import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/parking_lot.dart';
import '../admin/edit_lot_screen.dart';

class ParkingLotTab extends StatefulWidget {
  const ParkingLotTab({super.key});

  @override
  State<ParkingLotTab> createState() => _ParkingLotTabState();
}

class _ParkingLotTabState extends State<ParkingLotTab> {
  late Future<List<ParkingLot>> lots;

  @override
  void initState() {
    super.initState();
    lots = ApiService().getAdminLots();
  }

  void _refresh() {
    setState(() {
      lots = ApiService().getAdminLots();
    });
  }

  void _deleteLot(int id) async {
    await ApiService().deleteLot(id);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final created = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const EditLotScreen(),
              ));
          if (created == true) _refresh();
        },
      ),
      body: FutureBuilder<List<ParkingLot>>(
        future: lots,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final list = snapshot.data!;
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final lot = list[i];
                return ListTile(
                  title: Text(lot.name),
                  subtitle: Text(
                      "Slots: ${lot.totalSlots} - Available: ${lot.availableSlots}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditLotScreen(lot: lot),
                              ));
                          if (updated == true) _refresh();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteLot(lot.id),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("Lỗi tải bãi xe"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
