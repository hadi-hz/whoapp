import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  RxBool useSystemTheme = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  /// سوییچ بین light و dark (حالت دستی)
  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    // اگر حالت system فعال است، ابتدا حالت دستی فعال می‌شود
    if (useSystemTheme.value) {
      useSystemTheme.value = false;
      themeMode.value = ThemeMode.light;
    } else {
      themeMode.value =
          themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    }

    Get.changeThemeMode(themeMode.value);

    // ذخیره وضعیت
    await prefs.setBool('useSystemTheme', false);
    await prefs.setString(
      'themeMode',
      themeMode.value == ThemeMode.light ? 'light' : 'dark',
    );
  }

  /// انتخاب تم سیستم
  Future<void> setSystemTheme() async {
    final prefs = await SharedPreferences.getInstance();
    useSystemTheme.value = true;
    themeMode.value = ThemeMode.system;
    Get.changeThemeMode(ThemeMode.system);
    await prefs.setBool('useSystemTheme', true);
  }

  /// انتخاب دستی تم
  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    useSystemTheme.value = false;
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    await prefs.setBool('useSystemTheme', false);
    await prefs.setString(
      'themeMode',
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  /// بارگذاری تم ذخیره‌شده
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    useSystemTheme.value = prefs.getBool('useSystemTheme') ?? true;

    if (useSystemTheme.value) {
      themeMode.value = ThemeMode.system;
    } else {
      final saved = prefs.getString('themeMode') ?? 'light';
      themeMode.value = saved == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }

    Get.changeThemeMode(themeMode.value);
  }

  /// وضعیت فعلی تم (برای IconButton)
  bool isLightMode() {
    if (useSystemTheme.value) {
      final brightness = WidgetsBinding.instance.window.platformBrightness;
      return brightness == Brightness.light;
    } else {
      return themeMode.value == ThemeMode.light;
    }
  }
}
