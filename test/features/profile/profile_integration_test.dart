import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/profile/presentation/pages/profile.dart';

void main() {
  patrolTest('ProfilePage complete user flow test', ($) async {
    // Setup test environment
    await _setupTestEnvironment();

    // Launch ProfilePage
    await $.pumpWidgetAndSettle(_createProfilePageApp());

    // Test profile page loads and functionality
    await _verifyProfilePageLoaded($);
    await _testUserInformationDisplay($);
    await _testEditProfileFlow($);
    await _testChangePasswordFlow($);
    await _testThemeToggle($);
    await _testLanguageChange($);
    await _testLogoutFlow($);
  });

  patrolTest('ProfilePage form validation tests', ($) async {
    await _setupTestEnvironment();
    await $.pumpWidgetAndSettle(_createProfilePageApp());

    await _testEditProfileValidation($);
    await _testChangePasswordValidation($);
  });
}

Future<void> _setupTestEnvironment() async {
  SharedPreferences.setMockInitialValues({
    'userId': 'test-user-123',
    'userName': 'Test User',
    'userEmail': 'test@example.com',
    'role': 'Admin',
    'isUserApproved': true,
  });
}

Widget _createProfilePageApp() {
  return GetMaterialApp(
    home: const ProfilePage(),
    translations: TestTranslations(),
  );
}

Future<void> _verifyProfilePageLoaded(PatrolIntegrationTester $) async {
  expect(find.byType(ProfilePage), findsOneWidget);
  expect(find.text('WORLD HEALTH ORGANIZATION'), findsOneWidget);
  expect(find.byIcon(Icons.edit), findsOneWidget);
  expect(find.text('Change Password'), findsOneWidget);
  expect(find.text('Logout'), findsOneWidget);

  await $.pumpAndSettle();
}

Future<void> _testUserInformationDisplay(PatrolIntegrationTester $) async {
  expect(find.text('NAME'), findsOneWidget);
  expect(find.text('LAST NAME'), findsOneWidget);
  expect(find.text('EMAIL'), findsOneWidget);
  expect(find.text('ROLE'), findsOneWidget);

  await $.pumpAndSettle();
}

Future<void> _testEditProfileFlow(PatrolIntegrationTester $) async {
  await $(Icons.edit).tap();
  await $.pumpAndSettle();

  expect(find.text('Edit Profile'), findsOneWidget);

  await $(TextFormField).at(0).enterText('John Updated');
  await $(TextFormField).at(1).enterText('Doe Updated');
  await $.pumpAndSettle();

  await $('Save Profile').tap();
  await $.pumpAndSettle();
}

Future<void> _testChangePasswordFlow(PatrolIntegrationTester $) async {
  await $('Change Password').tap();
  await $.pumpAndSettle();

  expect(find.text('Enter New Password'), findsOneWidget);

  await $(TextFormField).at(0).enterText('currentPassword123');
  await $(TextFormField).at(1).enterText('newPassword123');
  await $.pumpAndSettle();

  await $('Change Password').last.tap();
  await $.pumpAndSettle();
}

Future<void> _testThemeToggle(PatrolIntegrationTester $) async {
  final themeButton = find.byIcon(Icons.dark_mode).first;
  if (themeButton.evaluate().isNotEmpty) {
    await $(Icons.dark_mode).tap();
  } else {
    await $(Icons.light_mode).tap();
  }
  await $.pumpAndSettle();
}

Future<void> _testLanguageChange(PatrolIntegrationTester $) async {
  await $(Icons.language).tap();
  await $.pumpAndSettle();

  if (find.text('English').evaluate().isNotEmpty) {
    await $('French').tap();
  }
  await $.pumpAndSettle();
}

Future<void> _testLogoutFlow(PatrolIntegrationTester $) async {
  await $('Logout').tap();
  await $.pumpAndSettle();

  expect(find.text('Confirm Logout'), findsOneWidget);
  expect(find.text('Are You Sure Logout'), findsOneWidget);

  await $('Logout').last.tap();
  await $.pumpAndSettle();
}

Future<void> _testEditProfileValidation(PatrolIntegrationTester $) async {
  await $(Icons.edit).tap();
  await $.pumpAndSettle();

  await $('Save Profile').tap();
  await $.pumpAndSettle();

  await $(Icons.close).tap();
  await $.pumpAndSettle();
}

Future<void> _testChangePasswordValidation(PatrolIntegrationTester $) async {
  await $('Change Password').tap();
  await $.pumpAndSettle();

  await $('Change Password').last.tap();
  await $.pumpAndSettle();

  expect(find.text('Current Password Required'), findsOneWidget);
  expect(find.text('New Password Required'), findsOneWidget);
}

class TestTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'world_health_organization': 'WORLD HEALTH ORGANIZATION',
      'name': 'Name',
      'lastname': 'Last Name',
      'email': 'Email',
      'role': 'Role',
      'edit_profile': 'Edit Profile',
      'change_password': 'Change Password',
      'logout': 'Logout',
      'confirm_logout': 'Confirm Logout',
      'are_you_sure_logout': 'Are You Sure Logout',
      'cancel': 'Cancel',
      'current_password': 'Current Password',
      'new_password': 'New Password',
      'enter_new_password': 'Enter New Password',
      'current_password_required': 'Current Password Required',
      'new_password_required': 'New Password Required',
      'save_profile': 'Save Profile',
    },
  };
}
