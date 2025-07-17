import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/parking_slot.dart';
import '../models/user.dart';
import '../models/parking_lot.dart';
import '../models/reservation.dart';

class ApiService {
  static const String baseUrl = "https://localhost:7082/api";

  User? currentUser;

  Future<User?> login(String username, String password) async {
    final res = await http.post(Uri.parse('$baseUrl/Auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}));

    if (res.statusCode == 200) {
      currentUser = User.fromJson(jsonDecode(res.body));
      return currentUser;
    } else {
      return null;
    }
  }

  Future<bool> register(
      String username, String password, String fullName) async {
    final res = await http.post(Uri.parse('$baseUrl/Auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'fullName': fullName,
          'role': 'Customer'
        }));

    return res.statusCode == 200;
  }

  Future<List<ParkingLot>> getParkingLots() async {
    final res = await http.get(Uri.parse('$baseUrl/Parking/lots'));
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return list.map((e) => ParkingLot.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch lots");
    }
  }

  Future<bool> reserveSlot(int slotId) async {
    if (currentUser == null) return false;
    final res = await http.post(Uri.parse('$baseUrl/Parking/reserve'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': currentUser!.id, 'slotId': slotId}));

    return res.statusCode == 200;
  }

  Future<List<Reservation>> getMyReservations() async {
    if (currentUser == null) return [];
    final res = await http
        .get(Uri.parse('$baseUrl/Reservations/user/${currentUser!.id}'));

    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return list.map((e) => Reservation.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<bool> cancelReservation(int reservationId) async {
    final res =
        await http.delete(Uri.parse('$baseUrl/Reservations/$reservationId'));
    return res.statusCode == 200;
  }

  Future<Map<String, dynamic>> getAdminDashboard() async {
    final res = await http.get(Uri.parse('$baseUrl/Admin/dashboard'));
    return jsonDecode(res.body);
  }

  Future<List<ParkingLot>> getAdminLots() async {
    final res = await http.get(Uri.parse('$baseUrl/Admin/lots'));
    final list = jsonDecode(res.body) as List;
    return list.map((e) => ParkingLot.fromJson(e)).toList();
  }

  Future<List<ParkingSlot>> getAdminSlots() async {
    final res = await http.get(Uri.parse('$baseUrl/Admin/slots'));
    final list = jsonDecode(res.body) as List;
    return list.map((e) => ParkingSlot.fromJson(e)).toList();
  }

  Future<void> deleteLot(int id) async {
    await http.delete(Uri.parse('$baseUrl/Admin/lots/$id'));
  }

  Future<void> deleteSlot(int id) async {
    await http.delete(Uri.parse('$baseUrl/Admin/slots/$id'));
  }

  Future<void> createLot(ParkingLot lot) async {
    await http.post(Uri.parse('$baseUrl/Admin/lots'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': lot.name,
          'address': lot.address,
          'totalSlots': lot.totalSlots,
          'availableSlots': lot.availableSlots
        }));
  }

  Future<void> updateLot(ParkingLot lot) async {
    await http.put(Uri.parse('$baseUrl/Admin/lots/${lot.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': lot.name,
          'address': lot.address,
          'totalSlots': lot.totalSlots,
          'availableSlots': lot.availableSlots
        }));
  }

  Future<void> createSlot(ParkingSlot slot) async {
    await http.post(Uri.parse('$baseUrl/Admin/slots'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'slotCode': slot.slotCode,
          'parkingLotId': slot.parkingLotId,
          'isOccupied': slot.isOccupied
        }));
  }

  Future<void> updateSlot(ParkingSlot slot) async {
    await http.put(Uri.parse('$baseUrl/Admin/slots/${slot.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'slotCode': slot.slotCode,
          'parkingLotId': slot.parkingLotId,
          'isOccupied': slot.isOccupied
        }));
  }
}
