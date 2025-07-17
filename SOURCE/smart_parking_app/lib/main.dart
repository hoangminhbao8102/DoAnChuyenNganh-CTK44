import 'package:flutter/material.dart';
import 'screens/admin/admin_main_screen.dart';
import 'screens/login_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget homeWidget;
    if (apiService.currentUser?.role == 'Admin') {
      homeWidget = const AdminMainScreen();
    } else {
      homeWidget = LoginScreen(apiService: apiService);
    }
    return MaterialApp(
      title: 'Smart Parking',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: homeWidget,
      debugShowCheckedModeBanner: false,
    );
  }
}
