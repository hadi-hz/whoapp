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

  int getLanguageCode(String locale) {
    switch (locale) {
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


  Future<String> getSelectedLanguageForRegister() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedLanguage') ?? 'en';
  }

  
  Future<void> setLanguageFromLogin(int languageCode) async {
    final languageString = _getLanguageString(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', languageString);
    Get.updateLocale(Locale(languageString));
  }

  Future<void> changeLanguage(String languageCode) async {
    try {
      isChangingLanguage.value = true;
      errorMessage.value = '';

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');


      if (userId == null) {
        Get.updateLocale(Locale(languageCode));
        await prefs.setString('selectedLanguage', languageCode);
        
        Get.snackbar(
          'success'.tr,
          'Language changed successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return;
      }

   
      Get.updateLocale(Locale(languageCode));

      final request = ChangeLanguageRequest(
        userId: userId,
        newLanguage: getLanguageCode(languageCode),
      );

      final response = await _changeLanguageUseCase.call(request);

      await prefs.setString('selectedLanguage', languageCode);

      Get.snackbar(
        'success'.tr,
        response.message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
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
}