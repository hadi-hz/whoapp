import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/auth/domain/entities/change_language.dart';
import 'package:test3/features/auth/domain/usecase/change_language_usecase.dart';

class LanguageController extends GetxController {
  final ChangeLanguageUseCase _changeLanguageUseCase;

  LanguageController(this._changeLanguageUseCase);

  final RxBool isChangingLanguage = false.obs;
  final RxString errorMessage = ''.obs;

  /// استفاده از زبان سیستم یا زبان کاربر
  final RxBool useSystemLocale = true.obs;

  /// زبان فعلی
  final Rx<Locale> locale = const Locale('en').obs;

  @override
  void onInit() {
    super.onInit();
    _loadLanguage();
  }

  /// متد کمکی برای تبدیل رشته به کد عددی
  int getLanguageCode(String localeStr) {
    switch (localeStr) {
      case 'en':
        return 0;
      case 'fr':
        return 1;
      case 'it':
        return 2;
      default:
        return 0;
    }
  }

  /// متد کمکی برای تبدیل کد عددی به رشته
  String _getLanguageString(int code) {
    switch (code) {
      case 0:
        return 'en';
      case 1:
        return 'fr';
      case 2:
        return 'it';
      default:
        return 'en';
    }
  }

  /// استفاده از زبان سیستم
  Future<void> setSystemLanguage() async {
    useSystemLocale.value = true;
    locale.value = Get.deviceLocale ?? const Locale('en');
    Get.updateLocale(locale.value);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useSystemLocale', true);
  }

  /// تغییر زبان به صورت دستی
  Future<void> changeLanguage(String languageCode) async {
    try {
      isChangingLanguage.value = true;
      errorMessage.value = '';
      useSystemLocale.value = false;

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      locale.value = Locale(languageCode);
      Get.updateLocale(locale.value);

      await prefs.setBool('useSystemLocale', false);
      await prefs.setString('selectedLanguage', languageCode);

      if (userId != null) {
        final request = ChangeLanguageRequest(
          userId: userId,
          newLanguage: getLanguageCode(languageCode),
        );

        final response = await _changeLanguageUseCase.call(request);

        Get.snackbar(
          'success'.tr,
          response.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'success'.tr,
          'Language changed successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'error'.tr,
        'Failed to change language: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isChangingLanguage.value = false;
    }
  }

  /// گرفتن زبان انتخاب‌شده برای ثبت‌نام
  Future<String> getSelectedLanguageForRegister() async {
    final prefs = await SharedPreferences.getInstance();
    final useSystem = prefs.getBool('useSystemLocale') ?? true;

    if (useSystem) {
      return (Get.deviceLocale?.languageCode ?? 'en');
    }

    return prefs.getString('selectedLanguage') ?? 'en';
  }

  /// تغییر زبان بعد از لاگین
  Future<void> setLanguageFromLogin(int languageCode) async {
    final languageString = _getLanguageString(languageCode);
    locale.value = Locale(languageString);
    useSystemLocale.value = false;

    Get.updateLocale(locale.value);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useSystemLocale', false);
    await prefs.setString('selectedLanguage', languageString);
  }

  /// بارگذاری زبان از SharedPreferences هنگام شروع برنامه
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    useSystemLocale.value = prefs.getBool('useSystemLocale') ?? true;

    if (useSystemLocale.value) {
      locale.value = Get.deviceLocale ?? const Locale('en');
    } else {
      final savedLang = prefs.getString('selectedLanguage') ?? 'en';
      locale.value = Locale(savedLang);
    }

    Get.updateLocale(locale.value);
  }
}
