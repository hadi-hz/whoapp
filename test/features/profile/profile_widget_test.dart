import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/profile/presentation/controller/profile_controller.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/core/theme/theme_controller.dart';
import 'package:test3/features/profile/domain/entities/info_user.dart';
import 'package:test3/features/profile/presentation/pages/profile.dart';

import 'profile_widget_test.mocks.dart';

@GenerateMocks([ProfileController, AuthController, ThemeController])
void main() {
  late MockProfileController mockProfileController;
  late MockAuthController mockAuthController;
  late MockThemeController mockThemeController;

  setUp(() {
    mockProfileController = MockProfileController();
    mockAuthController = MockAuthController();
    mockThemeController = MockThemeController();

    // Setup default mocks
    when(mockProfileController.showHello).thenReturn(true.obs);
    when(mockProfileController.userInfo).thenReturn(Rxn<UserInfo>());
    when(mockProfileController.imageFile).thenReturn(Rxn());
    when(mockProfileController.isLoadingChangePassword).thenReturn(false.obs);
    when(mockProfileController.isLoadingUpdate).thenReturn(false.obs);
    when(mockProfileController.name).thenReturn(TextEditingController());
    when(mockProfileController.lastName).thenReturn(TextEditingController());
    when(mockProfileController.currentPassword).thenReturn(TextEditingController());
    when(mockProfileController.newPassword).thenReturn(TextEditingController());
    when(mockThemeController.isLightMode()).thenReturn(true);

    Get.put<ProfileController>(mockProfileController);
    Get.put<AuthController>(mockAuthController);
    Get.put<ThemeController>(mockThemeController);

    SharedPreferences.setMockInitialValues({'userId': 'test-user-id'});
  });

  tearDown(() {
    Get.reset();
  });

  Widget createTestWidget() {
    return GetMaterialApp(
      home: const ProfilePage(),
      translations: TestTranslations(),
    );
  }

  group('ProfilePage Widget Tests', () {
    testWidgets('should render profile page correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ProfilePage), findsOneWidget);
      expect(find.text('WORLD HEALTH ORGANIZATION'), findsOneWidget);
    });

    testWidgets('should display user information when loaded', (tester) async {
      final userInfo = UserInfo(
        id: '1',
        name: 'John',
        lastname: 'Doe',
        email: 'john.doe@test.com',
        emailConfirmed: true,
        roles: ['Admin'],
        preferredLanguage: 0,
        isUserApproved: true,
      );
      
      when(mockProfileController.userInfo).thenReturn(userInfo.obs as Rxn<UserInfo>);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('John'), findsOneWidget);
      expect(find.text('Doe'), findsOneWidget);
      expect(find.text('john.doe@test.com'), findsOneWidget);
      expect(find.text('Admin'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should show error icon for unconfirmed email', (tester) async {
      final userInfo = UserInfo(
        id: '1',
        name: 'John',
        lastname: 'Doe',
        email: 'john.doe@test.com',
        emailConfirmed: false,
        roles: ['User'],
        preferredLanguage: 0,
        isUserApproved: true,
      );
      
      when(mockProfileController.userInfo).thenReturn(userInfo.obs as Rxn<UserInfo>);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('should toggle theme when theme button is tapped', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final themeButton = find.byIcon(Icons.dark_mode);
      expect(themeButton, findsOneWidget);

      await tester.tap(themeButton);
      verify(mockThemeController.toggleTheme()).called(1);
    });

    testWidgets('should open edit profile modal when edit button is tapped', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final editButton = find.byIcon(Icons.edit);
      expect(editButton, findsOneWidget);

      await tester.tap(editButton);
      await tester.pumpAndSettle();

      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
    });

    testWidgets('should open change password modal when button is tapped', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final changePasswordButton = find.text('Change Password');
      expect(changePasswordButton, findsOneWidget);

      await tester.tap(changePasswordButton);
      await tester.pumpAndSettle();

      expect(find.text('Enter New Password'), findsOneWidget);
      expect(find.text('Current Password'), findsOneWidget);
      expect(find.text('New Password'), findsOneWidget);
    });

    testWidgets('should show logout dialog when logout button is tapped', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final logoutButton = find.text('Logout');
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();

      expect(find.text('Confirm Logout'), findsOneWidget);
      expect(find.text('Are You Sure Logout'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('should call quickLogout when logout is confirmed', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Logout').last);
      verify(mockAuthController.quickLogout()).called(1);
    });

    testWidgets('should show loading indicator when updating profile', (tester) async {
      when(mockProfileController.isLoadingUpdate).thenReturn(true.obs);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('should show loading indicator when changing password', (tester) async {
      when(mockProfileController.isLoadingChangePassword).thenReturn(true.obs);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Change Password'));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('should validate form fields in change password modal', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Change Password'));
      await tester.pumpAndSettle();

      final changePasswordButton = find.text('Change Password').last;
      await tester.tap(changePasswordButton);
      await tester.pumpAndSettle();

      expect(find.text('Current Password Required'), findsOneWidget);
      expect(find.text('New Password Required'), findsOneWidget);
    });
  });
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