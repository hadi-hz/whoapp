import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/auth/presentation/controller/translation_controller.dart';
import 'package:test3/features/auth/domain/usecase/change_language_usecase.dart';
import 'package:test3/features/auth/domain/entities/change_language.dart';

import 'change_lang_unit_test.mocks.dart';

@GenerateMocks([ChangeLanguageUseCase])
void main() {
  late LanguageController controller;
  late MockChangeLanguageUseCase mockChangeLanguageUseCase;

  setUp(() {
    Get.testMode = true;
    
    mockChangeLanguageUseCase = MockChangeLanguageUseCase();
    controller = LanguageController(mockChangeLanguageUseCase);
    
    SharedPreferences.setMockInitialValues({
      'userId': 'test-user-123',
      'useSystemLocale': true,
      'selectedLanguage': 'en',
    });
  });

  tearDown(() {
    Get.reset();
  });

  group('LanguageController Unit Tests', () {
    group('Initialization', () {
      test('should initialize with default values', () {
        expect(controller.isChangingLanguage.value, false);
        expect(controller.errorMessage.value, '');
        expect(controller.useSystemLocale.value, true);
        expect(controller.locale.value, const Locale('en'));
      });

      test('should load language settings on init', () async {
        await controller.onInit();
        
        expect(controller.useSystemLocale.value, true);
        expect(controller.locale.value.languageCode, 'en');
      });
    });

    group('getLanguageCode', () {
      test('should return correct language codes', () {
        expect(controller.getLanguageCode('en'), 0);
        expect(controller.getLanguageCode('fr'), 1);
        expect(controller.getLanguageCode('it'), 2);
        expect(controller.getLanguageCode('unknown'), 0);
      });
    });

    group('setSystemLanguage', () {
      test('should set system language correctly', () async {
        await controller.setSystemLanguage();
        
        expect(controller.useSystemLocale.value, true);
        expect(controller.locale.value, isNotNull);
      });

      test('should save system language preference', () async {
        await controller.setSystemLanguage();
        
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('useSystemLocale'), true);
      });
    });

    group('changeLanguage', () {
      test('should change language successfully without user ID', () async {
        SharedPreferences.setMockInitialValues({});
        
        await controller.changeLanguage('fr');
        
        expect(controller.locale.value.languageCode, 'fr');
        expect(controller.useSystemLocale.value, false);
        expect(controller.isChangingLanguage.value, false);
        expect(controller.errorMessage.value, '');
      });

      test('should change language successfully with user ID', () async {
        final mockResponse = ChangeLanguageResponse(
          message: 'Language changed successfully',
          userId: 'test-user-123',
          newLanguage: 1,
        );
        
        when(mockChangeLanguageUseCase.call(any))
            .thenAnswer((_) async => mockResponse);

        await controller.changeLanguage('fr');
        
        expect(controller.locale.value.languageCode, 'fr');
        expect(controller.useSystemLocale.value, false);
        expect(controller.isChangingLanguage.value, false);
        
        verify(mockChangeLanguageUseCase.call(any)).called(1);
      });

      test('should handle change language error', () async {
        when(mockChangeLanguageUseCase.call(any))
            .thenThrow(Exception('Network error'));

        await controller.changeLanguage('fr');
        
        expect(controller.errorMessage.value, contains('Exception: Network error'));
        expect(controller.isChangingLanguage.value, false);
      });

      test('should set loading state during language change', () async {
        when(mockChangeLanguageUseCase.call(any))
            .thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return ChangeLanguageResponse(
            message: 'Success',
            userId: 'test-user-123',
            newLanguage: 1,
          );
        });

        final future = controller.changeLanguage('fr');
        expect(controller.isChangingLanguage.value, true);

        await future;
        expect(controller.isChangingLanguage.value, false);
      });

      test('should save language preference to SharedPreferences', () async {
        await controller.changeLanguage('it');
        
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('useSystemLocale'), false);
        expect(prefs.getString('selectedLanguage'), 'it');
      });
    });

    group('getSelectedLanguageForRegister', () {
      test('should return device language when using system locale', () async {
        SharedPreferences.setMockInitialValues({
          'useSystemLocale': true,
        });
        
        final language = await controller.getSelectedLanguageForRegister();
        
        expect(language, isNotNull);
        expect(['en', 'fr', 'it'].contains(language), true);
      });

      test('should return saved language when not using system locale', () async {
        SharedPreferences.setMockInitialValues({
          'useSystemLocale': false,
          'selectedLanguage': 'fr',
        });
        
        final language = await controller.getSelectedLanguageForRegister();
        
        expect(language, 'fr');
      });

      test('should return default language when no saved preference', () async {
        SharedPreferences.setMockInitialValues({
          'useSystemLocale': false,
        });
        
        final language = await controller.getSelectedLanguageForRegister();
        
        expect(language, 'en');
      });
    });

    group('setLanguageFromLogin', () {
      test('should set language from login code 0 (English)', () async {
        await controller.setLanguageFromLogin(0);
        
        expect(controller.locale.value.languageCode, 'en');
        expect(controller.useSystemLocale.value, false);
        
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('useSystemLocale'), false);
        expect(prefs.getString('selectedLanguage'), 'en');
      });

      test('should set language from login code 1 (French)', () async {
        await controller.setLanguageFromLogin(1);
        
        expect(controller.locale.value.languageCode, 'fr');
        expect(controller.useSystemLocale.value, false);
        
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('selectedLanguage'), 'fr');
      });

      test('should set language from login code 2 (Italian)', () async {
        await controller.setLanguageFromLogin(2);
        
        expect(controller.locale.value.languageCode, 'it');
        expect(controller.useSystemLocale.value, false);
        
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('selectedLanguage'), 'it');
      });

      test('should default to English for unknown language code', () async {
        await controller.setLanguageFromLogin(999);
        
        expect(controller.locale.value.languageCode, 'en');
      });
    });

    group('_loadLanguage', () {
      test('should load system language when useSystemLocale is true', () async {
        SharedPreferences.setMockInitialValues({
          'useSystemLocale': true,
        });
        
        await controller._loadLanguage();
        
        expect(controller.useSystemLocale.value, true);
        expect(controller.locale.value, isNotNull);
      });

      test('should load saved language when useSystemLocale is false', () async {
        SharedPreferences.setMockInitialValues({
          'useSystemLocale': false,
          'selectedLanguage': 'it',
        });
        
        await controller._loadLanguage();
        
        expect(controller.useSystemLocale.value, false);
        expect(controller.locale.value.languageCode, 'it');
      });

      test('should default to English when no saved language', () async {
        SharedPreferences.setMockInitialValues({
          'useSystemLocale': false,
        });
        
        await controller._loadLanguage();
        
        expect(controller.locale.value.languageCode, 'en');
      });

      test('should default to system language when no preferences', () async {
        SharedPreferences.setMockInitialValues({});
        
        await controller._loadLanguage();
        
        expect(controller.useSystemLocale.value, true);
      });
    });

    group('Language Code Conversion', () {
      test('should convert language strings to correct codes', () {
        expect(controller.getLanguageCode('en'), 0);
        expect(controller.getLanguageCode('fr'), 1);
        expect(controller.getLanguageCode('it'), 2);
      });

      test('should handle invalid language codes gracefully', () {
        expect(controller.getLanguageCode(''), 0);
        expect(controller.getLanguageCode('invalid'), 0);
        expect(controller.getLanguageCode('de'), 0);
      });
    });

    group('Reactive Properties', () {
      test('should update isChangingLanguage reactively', () async {
        expect(controller.isChangingLanguage.value, false);
        
        when(mockChangeLanguageUseCase.call(any))
            .thenAnswer((_) async {
          expect(controller.isChangingLanguage.value, true);
          return ChangeLanguageResponse(
            message: 'Success',
            userId: 'test-user-123',
            newLanguage: 1,
          );
        });

        await controller.changeLanguage('fr');
        expect(controller.isChangingLanguage.value, false);
      });

      test('should update locale reactively', () async {
        expect(controller.locale.value.languageCode, 'en');
        
        await controller.changeLanguage('fr');
        expect(controller.locale.value.languageCode, 'fr');
        
        await controller.changeLanguage('it');
        expect(controller.locale.value.languageCode, 'it');
      });

      test('should update useSystemLocale reactively', () async {
        expect(controller.useSystemLocale.value, true);
        
        await controller.changeLanguage('fr');
        expect(controller.useSystemLocale.value, false);
        
        await controller.setSystemLanguage();
        expect(controller.useSystemLocale.value, true);
      });
    });
  });
}