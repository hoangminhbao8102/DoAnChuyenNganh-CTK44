import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  Map<String, dynamic>? stats;

  @override
  void initState() {
    super.initState();
    _fetchDashboard();
  }

  Future<void> _fetchDashboard() async {
    final res = await ApiService().getAdminDashboard();
    setState(() {
      stats = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (stats == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStatTile("Người dùng", stats!['totalUsers']),
        _buildStatTile("Bãi đậu xe", stats!['totalLots']),
        _buildStatTile("Chỗ đậu", stats!['totalSlots']),
        _buildStatTile("Đã đặt chỗ", stats!['totalReservations']),
        _buildStatTile("Đang sử dụng", stats!['occupiedSlots']),
      ],
    );
  }

  Widget _buildStatTile(String title, dynamic value) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing:
            Text("$value", style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
