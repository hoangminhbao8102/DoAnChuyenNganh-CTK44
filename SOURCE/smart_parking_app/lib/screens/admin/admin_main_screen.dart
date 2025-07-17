import 'package:flutter/material.dart';
import 'dashboard_tab.dart';
import 'parking_lot_tab.dart';
import 'slot_tab.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;

  final tabs = [
    const DashboardTab(),
    const ParkingLotTab(),
    const SlotTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin - Smart Parking")),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Thống kê"),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_parking), label: "Bãi xe"),
          BottomNavigationBarItem(icon: Icon(Icons.event_seat), label: "Slot"),
        ],
      ),
    );
  }
}
