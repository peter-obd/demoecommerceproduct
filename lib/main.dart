import 'package:demoecommerceproduct/controllers/login_controller.dart';
import 'package:demoecommerceproduct/controllers/welcome_controller.dart';
import 'package:demoecommerceproduct/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

void main() {
  Get.put(WelcomeController());
  Get.put(LoginController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
