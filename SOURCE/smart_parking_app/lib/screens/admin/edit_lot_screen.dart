import 'package:flutter/material.dart';
import '../../models/parking_lot.dart';
import '../../services/api_service.dart';

class EditLotScreen extends StatefulWidget {
  final ParkingLot? lot;

  const EditLotScreen({super.key, this.lot});

  @override
  State<EditLotScreen> createState() => _EditLotScreenState();
}

class _EditLotScreenState extends State<EditLotScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final totalCtrl = TextEditingController();
  final availableCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.lot != null) {
      nameCtrl.text = widget.lot!.name;
      addressCtrl.text = widget.lot!.address;
      totalCtrl.text = widget.lot!.totalSlots.toString();
      availableCtrl.text = widget.lot!.availableSlots.toString();
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final lot = ParkingLot(
        id: widget.lot?.id ?? 0,
        name: nameCtrl.text,
        address: addressCtrl.text,
        totalSlots: int.parse(totalCtrl.text),
        availableSlots: int.parse(availableCtrl.text),
        parkingSlots: [],
      );

      if (widget.lot == null) {
        await ApiService().createLot(lot);
      } else {
        await ApiService().updateLot(lot);
      }

      if (context.mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.lot == null ? "Thêm bãi xe" : "Sửa bãi xe")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Tên bãi xe"),
                validator: (v) => v!.isEmpty ? "Nhập tên" : null),
            TextFormField(
                controller: addressCtrl,
                decoration: const InputDecoration(labelText: "Địa chỉ")),
            TextFormField(
                controller: totalCtrl,
                decoration: const InputDecoration(labelText: "Tổng chỗ"),
                keyboardType: TextInputType.number),
            TextFormField(
                controller: availableCtrl,
                decoration: const InputDecoration(labelText: "Chỗ trống"),
                keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text("Lưu"))
          ]),
        ),
      ),
    );
  }
}
