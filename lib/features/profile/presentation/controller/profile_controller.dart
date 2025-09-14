import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/profile/domain/entities/change_password.dart';
import 'package:test3/features/profile/domain/entities/info_user.dart';
import 'package:test3/features/profile/domain/entities/update_user.dart';
import 'package:test3/features/profile/domain/usecase/chnage_password_usecase.dart';
import 'package:test3/features/profile/domain/usecase/get_user_info_usecase.dart';
import 'package:test3/features/profile/domain/usecase/update_user_profile_usecase.dart';

class ProfileController extends GetxController {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;
  final ChangePasswordUseCase changePasswordUseCase;

  ProfileController(
    this.getUserProfile,
    this.updateUserProfile,
    this.changePasswordUseCase,
  );

  var userInfo = Rxn<UserInfo>();
  var userUpdateInfo = Rxn<UserUpdate>();
  var isLoading = false.obs;
  var isLoadingUpdate = false.obs;
  RxBool isLoadingChangePassword = false.obs;

  RxBool showHello = false.obs;
  RxBool showWelcome = false.obs;
  RxBool showSignIn = false.obs;

  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();

  final TextEditingController name = TextEditingController();
  final TextEditingController lastName = TextEditingController();

  final Rx<File?> imageFile = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!isClosed) showHello.value = true;
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!isClosed) showWelcome.value = true;
    });
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (!isClosed) showSignIn.value = true;
    });
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final savedUserId = prefs.getString('userId') ?? '';
      final result = await getUserProfile(savedUserId);
      userInfo.value = result;
    } catch (e) {
      Get.snackbar('error'.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(String userId) async {
    try {
      isLoadingUpdate.value = true;
      final result = await updateUserProfile(
        userId: userId,
        name: name.text,
        lastname: lastName.text,
        profilePhoto: imageFile.value,
      );
      userUpdateInfo.value = result;

      Get.snackbar(
        'success'.tr,
        '${'profile_updated_for'.tr} ${userUpdateInfo.value?.name} ${userUpdateInfo.value?.lastname}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingUpdate.value = false;
    }
  }

  Future<void> changePassword(String userId) async {
    try {
      isLoadingChangePassword.value = true;
      final ChangePassword result = await changePasswordUseCase(
        userId: userId,
        currentPassword: currentPassword.text,
        newPassword: newPassword.text,
      );

      Get.snackbar(
        'success'.tr,
        result.message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      currentPassword.clear();
      newPassword.clear();
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingChangePassword.value = false;
    }
  }
}
