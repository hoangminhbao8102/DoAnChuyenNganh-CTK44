import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/parking_slot.dart';
import '../admin/edit_slot_screen.dart';

class SlotTab extends StatefulWidget {
  const SlotTab({super.key});

  @override
  State<SlotTab> createState() => _SlotTabState();
}

class _SlotTabState extends State<SlotTab> {
  List<ParkingSlot> slots = [];

  @override
  void initState() {
    super.initState();
    _loadSlots();
  }

  void _loadSlots() async {
    final s = await ApiService().getAdminSlots();
    setState(() => slots = s);
  }

  void _deleteSlot(int id) async {
    await ApiService().deleteSlot(id);
    _loadSlots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push(context,
              MaterialPageRoute(builder: (_) => const EditSlotScreen()));
          if (created == true) _loadSlots();
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: slots.length,
        itemBuilder: (context, i) {
          final slot = slots[i];
          return ListTile(
            title: Text("Slot: ${slot.slotCode}"),
            subtitle: Text(
                "Bãi: ${slot.parkingLotId} | Trạng thái: ${slot.isOccupied ? 'Đã đặt' : 'Trống'}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EditSlotScreen(slot: slot)));
                    if (updated == true) _loadSlots();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteSlot(slot.id),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
