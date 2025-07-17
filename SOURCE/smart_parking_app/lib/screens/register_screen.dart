import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatelessWidget {
  final ApiService apiService;
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  RegisterScreen({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Họ tên")),
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
              final success = await apiService.register(userController.text,
                  passController.text, nameController.text);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(success ? "Đăng ký thành công" : "Thất bại")));
              if (success) Navigator.pop(context);
            },
            child: const Text("Đăng ký"),
          ),
        ]),
      ),
    );
  }
}
