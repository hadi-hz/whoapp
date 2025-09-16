import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/profile/presentation/controller/profile_controller.dart';
import 'package:test3/features/profile/domain/usecase/get_user_info_usecase.dart';
import 'package:test3/features/profile/domain/usecase/update_user_profile_usecase.dart';
import 'package:test3/features/profile/domain/usecase/chnage_password_usecase.dart';
import 'package:test3/features/profile/domain/entities/info_user.dart';
import 'package:test3/features/profile/domain/entities/update_user.dart';
import 'package:test3/features/profile/domain/entities/change_password.dart';

import 'profile_unit_test.mocks.dart';

@GenerateMocks([
  GetUserProfile,
  UpdateUserProfile,
  ChangePasswordUseCase,
])
void main() {
  late ProfileController controller;
  late MockGetUserProfile mockGetUserProfile;
  late MockUpdateUserProfile mockUpdateUserProfile;
  late MockChangePasswordUseCase mockChangePasswordUseCase;

  setUp(() {
    Get.testMode = true;
    
    mockGetUserProfile = MockGetUserProfile();
    mockUpdateUserProfile = MockUpdateUserProfile();
    mockChangePasswordUseCase = MockChangePasswordUseCase();

    controller = ProfileController(
      mockGetUserProfile,
      mockUpdateUserProfile,
      mockChangePasswordUseCase,
    );

    SharedPreferences.setMockInitialValues({
      'userId': 'test-user-123',
    });
  });

  tearDown(() {
    Get.reset();
  });

  group('ProfileController Unit Tests', () {
    group('Initialization', () {
      test('should initialize with default values', () {
        expect(controller.userInfo.value, isNull);
        expect(controller.isLoading.value, false);
        expect(controller.isLoadingUpdate.value, false);
        expect(controller.isLoadingChangePassword.value, false);
        expect(controller.showHello.value, false);
        expect(controller.imageFile.value, isNull);
      });

      test('should start animations on init', () async {
        controller.onInit();
        
        expect(controller.showHello.value, false);
        expect(controller.showWelcome.value, false);
        expect(controller.showSignIn.value, false);

        await Future.delayed(const Duration(milliseconds: 350));
        expect(controller.showHello.value, true);

        await Future.delayed(const Duration(milliseconds: 400));
        expect(controller.showWelcome.value, true);

        await Future.delayed(const Duration(milliseconds: 450));
        expect(controller.showSignIn.value, true);
      });
    });

    group('fetchUserProfile', () {
      test('should fetch user profile successfully', () async {
        final userInfo = UserInfo(
          id: 'test-user-123',
          name: 'John',
          lastname: 'Doe',
          email: 'john@test.com',
          emailConfirmed: true,
          roles: ['Admin'],
          preferredLanguage: 0,
          isUserApproved: true,
        );

        when(mockGetUserProfile.call('test-user-123'))
            .thenAnswer((_) async => userInfo);

        await controller.fetchUserProfile();

        expect(controller.userInfo.value, equals(userInfo));
        expect(controller.isLoading.value, false);
        verify(mockGetUserProfile.call('test-user-123')).called(1);
      });

      test('should handle fetch user profile error', () async {
        when(mockGetUserProfile.call('test-user-123'))
            .thenThrow(Exception('Network error'));

        await controller.fetchUserProfile();

        expect(controller.userInfo.value, isNull);
        expect(controller.isLoading.value, false);
        verify(mockGetUserProfile.call('test-user-123')).called(1);
      });

      test('should set loading state during fetch', () async {
        when(mockGetUserProfile.call('test-user-123'))
            .thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return UserInfo(
            id: 'test-user-123',
            name: 'John',
            lastname: 'Doe',
            email: 'john@test.com',
            emailConfirmed: true,
            roles: ['Admin'],
            preferredLanguage: 0,
            isUserApproved: true,
          );
        });

        final future = controller.fetchUserProfile();
        expect(controller.isLoading.value, true);

        await future;
        expect(controller.isLoading.value, false);
      });
    });

    group('updateProfile', () {
      test('should update profile successfully', () async {
        controller.name.text = 'Jane';
        controller.lastName.text = 'Smith';

        final updateResult = UserUpdate(
          id: 'test-user-123',
          name: 'Jane',
          lastname: 'Smith',
          message: 'Profile updated successfully',
        );

        when(mockUpdateUserProfile.call(
          userId: 'test-user-123',
          name: 'Jane',
          lastname: 'Smith',
          profilePhoto: null,
        )).thenAnswer((_) async => updateResult);

        await controller.updateProfile('test-user-123');

        expect(controller.userUpdateInfo.value, equals(updateResult));
        expect(controller.isLoadingUpdate.value, false);
        verify(mockUpdateUserProfile.call(
          userId: 'test-user-123',
          name: 'Jane',
          lastname: 'Smith',
          profilePhoto: null,
        )).called(1);
      });

      test('should handle update profile error', () async {
        controller.name.text = 'Jane';
        controller.lastName.text = 'Smith';

        when(mockUpdateUserProfile.call(
          userId: 'test-user-123',
          name: 'Jane',
          lastname: 'Smith',
          profilePhoto: null,
        )).thenThrow(Exception('Update failed'));

        await controller.updateProfile('test-user-123');

        expect(controller.isLoadingUpdate.value, false);
        verify(mockUpdateUserProfile.call(
          userId: 'test-user-123',
          name: 'Jane',
          lastname: 'Smith',
          profilePhoto: null,
        )).called(1);
      });

      test('should set loading state during update', () async {
        controller.name.text = 'Jane';
        controller.lastName.text = 'Smith';

        when(mockUpdateUserProfile.call(
          userId: anyNamed('userId'),
          name: anyNamed('name'),
          lastname: anyNamed('lastname'),
          profilePhoto: anyNamed('profilePhoto'),
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return UserUpdate(
            id: 'test-user-123',
            name: 'Jane',
            lastname: 'Smith',
            message: 'Updated',
          );
        });

        final future = controller.updateProfile('test-user-123');
        expect(controller.isLoadingUpdate.value, true);

        await future;
        expect(controller.isLoadingUpdate.value, false);
      });
    });

    group('changePassword', () {
      test('should change password successfully', () async {
        controller.currentPassword.text = 'oldPassword';
        controller.newPassword.text = 'newPassword';

        final changePasswordResult = ChangePassword(
          message: 'Password changed successfully',
        );

        when(mockChangePasswordUseCase.call(
          userId: 'test-user-123',
          currentPassword: 'oldPassword',
          newPassword: 'newPassword',
        )).thenAnswer((_) async => changePasswordResult);

        await controller.changePassword('test-user-123');

        expect(controller.isLoadingChangePassword.value, false);
        expect(controller.currentPassword.text, isEmpty);
        expect(controller.newPassword.text, isEmpty);
        verify(mockChangePasswordUseCase.call(
          userId: 'test-user-123',
          currentPassword: 'oldPassword',
          newPassword: 'newPassword',
        )).called(1);
      });

      test('should handle change password error', () async {
        controller.currentPassword.text = 'oldPassword';
        controller.newPassword.text = 'newPassword';

        when(mockChangePasswordUseCase.call(
          userId: 'test-user-123',
          currentPassword: 'oldPassword',
          newPassword: 'newPassword',
        )).thenThrow(Exception('Invalid current password'));

        await controller.changePassword('test-user-123');

        expect(controller.isLoadingChangePassword.value, false);
        verify(mockChangePasswordUseCase.call(
          userId: 'test-user-123',
          currentPassword: 'oldPassword',
          newPassword: 'newPassword',
        )).called(1);
      });

      test('should set loading state during password change', () async {
        controller.currentPassword.text = 'oldPassword';
        controller.newPassword.text = 'newPassword';

        when(mockChangePasswordUseCase.call(
          userId: anyNamed('userId'),
          currentPassword: anyNamed('currentPassword'),
          newPassword: anyNamed('newPassword'),
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return ChangePassword(message: 'Success');
        });

        final future = controller.changePassword('test-user-123');
        expect(controller.isLoadingChangePassword.value, true);

        await future;
        expect(controller.isLoadingChangePassword.value, false);
      });
    });

    group('pickImage', () {
      test('should update imageFile when image is picked', () async {
        controller.imageFile.value = null;
        
        // Note: This test would require mocking ImagePicker
        // For now, just test the reactive variable
        final testFile = File('test/path/image.jpg');
        controller.imageFile.value = testFile;
        
        expect(controller.imageFile.value, equals(testFile));
      });
    });

    group('Text Controllers', () {
      test('should clear text controllers when needed', () {
        controller.name.text = 'John';
        controller.lastName.text = 'Doe';
        controller.currentPassword.text = 'password';
        controller.newPassword.text = 'newPassword';

        controller.name.clear();
        controller.lastName.clear();
        controller.currentPassword.clear();
        controller.newPassword.clear();

        expect(controller.name.text, isEmpty);
        expect(controller.lastName.text, isEmpty);
        expect(controller.currentPassword.text, isEmpty);
        expect(controller.newPassword.text, isEmpty);
      });
    });
  });
}