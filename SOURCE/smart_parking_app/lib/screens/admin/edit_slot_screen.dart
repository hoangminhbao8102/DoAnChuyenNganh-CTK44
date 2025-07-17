import 'package:flutter/material.dart';
import '../../models/parking_lot.dart';
import '../../models/parking_slot.dart';
import '../../services/api_service.dart';

class EditSlotScreen extends StatefulWidget {
  final ParkingSlot? slot;

  const EditSlotScreen({super.key, this.slot});

  @override
  State<EditSlotScreen> createState() => _EditSlotScreenState();
}

class _EditSlotScreenState extends State<EditSlotScreen> {
  final _formKey = GlobalKey<FormState>();
  final codeCtrl = TextEditingController();
  int? selectedLotId;
  bool isOccupied = false;
  List<ParkingLot> lots = [];

  @override
  void initState() {
    super.initState();
    if (widget.slot != null) {
      codeCtrl.text = widget.slot!.slotCode;
      selectedLotId = widget.slot!.parkingLotId;
      isOccupied = widget.slot!.isOccupied;
    }

    ApiService().getAdminLots().then((list) {
      setState(() {
        lots = list;
        selectedLotId ??= list.isNotEmpty ? list[0].id : null;
      });
    });
  }

  void _save() async {
    if (_formKey.currentState!.validate() && selectedLotId != null) {
      final slot = ParkingSlot(
        id: widget.slot?.id ?? 0,
        slotCode: codeCtrl.text,
        parkingLotId: selectedLotId!,
        isOccupied: isOccupied,
      );

      if (widget.slot == null) {
        await ApiService().createSlot(slot);
      } else {
        await ApiService().updateSlot(slot);
      }

      if (context.mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.slot == null ? "Thêm slot" : "Sửa slot")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
                controller: codeCtrl,
                decoration: const InputDecoration(labelText: "Mã slot")),
            DropdownButtonFormField<int>(
              value: selectedLotId,
              items: lots
                  .map((lot) =>
                      DropdownMenuItem(value: lot.id, child: Text(lot.name)))
                  .toList(),
              onChanged: (value) => setState(() => selectedLotId = value),
              decoration: const InputDecoration(labelText: "Bãi đậu xe"),
            ),
            SwitchListTile(
              value: isOccupied,
              onChanged: (val) => setState(() => isOccupied = val),
              title: const Text("Đang sử dụng"),
            ),
            ElevatedButton(onPressed: _save, child: const Text("Lưu"))
          ]),
        ),
      ),
    );
  }
}
