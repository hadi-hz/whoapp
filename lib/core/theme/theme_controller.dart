import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  var themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void toggleTheme() {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.light;
    }
    Get.changeThemeMode(themeMode.value);
    _saveTheme(themeMode.value);
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'themeMode',
      mode == ThemeMode.light ? 'light' : 'dark',
    );
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('themeMode') ?? 'light';
    themeMode.value = savedTheme == 'light' ? ThemeMode.light : ThemeMode.dark;
    Get.changeThemeMode(themeMode.value);
  }
}