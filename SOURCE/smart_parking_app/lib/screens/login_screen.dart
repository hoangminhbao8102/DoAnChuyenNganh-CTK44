// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'parking_lot_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  final ApiService apiService;
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  LoginScreen({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng nhập")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(
              controller: userController,
              decoration: const InputDecoration(labelText: "Username")),
          TextField(
              controller: passController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password")),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final user = await apiService.login(
                  userController.text, passController.text);
              print("User login result: $user"); // Log kết quả

              if (user != null) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            ParkingLotScreen(apiService: apiService)));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Sai thông tin đăng nhập")));
              }
            },
            child: const Text("Đăng nhập"),
          ),
          TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => RegisterScreen(apiService: apiService))),
            child: const Text("Chưa có tài khoản? Đăng ký"),
          )
        ]),
      ),
    );
  }
}
