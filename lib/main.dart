// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_app/controllers/theme_controller.dart';
import 'package:mental_health_app/screens/Presentation/splash_screen.dart';
import 'package:mental_health_app/utils/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeController controller = Get.put(ThemeController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mental Health App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}