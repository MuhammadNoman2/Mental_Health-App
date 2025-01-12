
// theme_controller.dart (for GetX theme switching)
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();
  var _isDarkTheme = false.obs;

  ThemeMode get themeMode => _isDarkTheme.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme.value = !_isDarkTheme.value;
    Get.changeThemeMode(_isDarkTheme.value ? ThemeMode.dark : ThemeMode.light);
  }
}
