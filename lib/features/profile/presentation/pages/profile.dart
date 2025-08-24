import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/auth/presentation/pages/widgets/box_neumorphysm.dart';
import 'package:test3/features/auth/presentation/pages/widgets/text_filed.dart';
import 'package:test3/features/profile/presentation/controller/profile_controller.dart';
import 'package:test3/shared/change_lang.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController controller = Get.find<ProfileController>();
  final AuthController authController = Get.find<AuthController>();
  final formKeyChangePassword = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final savedUserId = prefs.getString('userId') ?? '';
      await controller.fetchUserProfile(savedUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, child: bodyTitles(context)),
          Positioned(
            top: screenHeight * 0.26,
            child: Container(
              width: screenWidth,
              height: screenHeight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [ChangeLang()],
                  ),
                  ConstantSpace.mediumVerticalSpacer,
                  userNameBox(),
                  ConstantSpace.largeVerticalSpacer,
                  fullNameBox(),
                  ConstantSpace.largeVerticalSpacer,
                  emailBox(),
                  ConstantSpace.largeVerticalSpacer,
                  roleBox(),
                  ConstantSpace.largeVerticalSpacer,
                  changePasswordButton(),
                  ConstantSpace.largeVerticalSpacer,
                  Row(
                    children: [
                      logoutButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.23 - 25,
            left: (screenWidth / 2) - 50,
            child: profileCircle(),
          ),
        ],
      ),
    );
  }

  Widget userNameBox() {
    return Obx(() {
      return Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'name'.tr.toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),

              Text(
                '${controller.userInfo.value?.name ?? ''}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget fullNameBox() {
    return Obx(() {
      return Row(
        children: [
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'lastname'.tr.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),

                  Text(
                    '${controller.userInfo.value?.lastname ?? ''}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget emailBox() {
    return Obx(() {
      return Row(
        children: [
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'email'.tr.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),

                  Row(
                    children: [
                      Text(
                        '${controller.userInfo.value?.email ?? ''}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      ConstantSpace.smallHorizontalSpacer,
                      controller.userInfo.value?.emailConfirmed == true
                          ? Icon(Icons.check_circle, color: Colors.green)
                          : Icon(Icons.error, color: Colors.red),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget roleBox() {
    return Obx(() {
      return Row(
        children: [
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'role'.tr.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),

                  Text(
                    '${controller.userInfo.value?.roles.first ?? ''}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget animatedText(bool show, Widget child) {
    return AnimatedOpacity(
      opacity: show ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: AnimatedSlide(
        offset: show ? const Offset(0, 0) : const Offset(0, 0.3),
        duration: const Duration(milliseconds: 200),
        child: child,
      ),
    );
  }

  Widget bodyTitles(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 500,
      color: AppColors.primaryColor,
      child: Column(
        children: [
          ConstantSpace.largeVerticalSpacer,
          ConstantSpace.largeVerticalSpacer,

          Obx(
            () => Row(
              children: [
                ConstantSpace.mediumHorizontalSpacer,
                AnimatedOpacity(
                  opacity: controller.showHello.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: AnimatedScale(
                    scale: controller.showHello.value ? 1.0 : 0.8,
                    duration: const Duration(milliseconds: 200),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => animatedText(controller.showHello.value, title()),
                    ),
                    Obx(
                      () => animatedText(
                        controller.showWelcome.value,
                        description(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget profileCircle() {
    return Obx(() {
      final file = controller.imageFile.value;
      final networkUrl = controller.userInfo.value?.profileImageUrl;
      return Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 223, 221, 221),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: file != null
                  ? Image.file(file, fit: BoxFit.cover)
                  : (networkUrl != null
                        ? Image.network(networkUrl, fit: BoxFit.cover)
                        : Icon(Icons.person, size: 50, color: Colors.white)),
            ),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.edit, size: 18, color: Colors.white),
                onPressed: () {
                  Get.bottomSheet(
                    Form(
                      key: formKey,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 20,
                            bottom: 30,
                            end: 20,
                            top: 12,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: context.width * 0.28,
                                child: Divider(
                                  color: AppColors.textColor,
                                  thickness: 4,
                                  radius: BorderRadius.all(Radius.circular(22)),
                                ),
                              ),
                              ConstantSpace.mediumVerticalSpacer,
                              chooseImageProfile(),
                              ConstantSpace.mediumVerticalSpacer,
                              inputName(context, controller.name),
                              ConstantSpace.mediumVerticalSpacer,
                              inputLastName(context, controller.lastName),

                              ConstantSpace.largeVerticalSpacer,
                              buttonSaveProfile(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget chooseImageProfile() {
    return Stack(
      children: [
        Obx(
          () => Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(width: 3, color: AppColors.primaryColor),
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 223, 221, 221),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: controller.imageFile.value == null
                  ? Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.backgroundColor,
                    )
                  : Image.file(
                      controller.imageFile.value as File,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.add_a_photo_rounded,
                size: 18,
                color: Colors.white,
              ),
              onPressed: controller.pickImage,
            ),
          ),
        ),
      ],
    );
  }

  Widget title() {
    return Row(
      children: [
        ConstantSpace.mediumHorizontalSpacer,
        Text(
          "world_health_organization".tr.split(' ').first,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.backgroundColor,
          ),
        ),
      ],
    );
  }

  Widget description() {
    return Row(
      children: [
        ConstantSpace.mediumHorizontalSpacer,
        Text(
          "world_health_organization".tr.split(' ').last,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.backgroundColor,
          ),
        ),
      ],
    );
  }

  Widget inputName(BuildContext context, controller) {
    return TextFieldInnerShadow(
      borderRadius: 16,
      controller: controller,
      hintText: 'name'.tr,
      prefixIcon: const Icon(Icons.person),
      validator: (p0) {
        return null;
      },
      width: MediaQuery.sizeOf(context).width * 0.82,
    );
  }

  Widget inputEmail(BuildContext context, controller) {
    return TextFieldInnerShadow(
      borderRadius: 16,
      controller: controller,
      hintText: 'email'.tr,
      prefixIcon: const Icon(Icons.email),
      validator: (p0) {
        return null;
      },
      width: MediaQuery.sizeOf(context).width * 0.82,
    );
  }

  Widget inputLastName(BuildContext context, controller) {
    return TextFieldInnerShadow(
      borderRadius: 16,
      controller: controller,
      hintText: 'lastname'.tr,
      prefixIcon: const Icon(Icons.person),
      validator: (p0) {
        return null;
      },
      width: MediaQuery.sizeOf(context).width * 0.82,
    );
  }

  Widget changePasswordButton() {
    return InkWell(
      onTap: () {
        Get.bottomSheet(
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Form(
              key: formKeyChangePassword,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 20,
                  bottom: 30,
                  end: 20,
                  top: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: context.width * 0.28,
                      child: Divider(
                        color: AppColors.textColor,
                        thickness: 4,
                        radius: BorderRadius.all(Radius.circular(22)),
                      ),
                    ),
                    ConstantSpace.mediumVerticalSpacer,
                    changePasswordInformation(),
                    ConstantSpace.largeVerticalSpacer,
                    inputCurrentPassword(context, controller.currentPassword),
                    ConstantSpace.mediumVerticalSpacer,
                    inputNewPassword(context, controller.newPassword),
                    ConstantSpace.largeVerticalSpacer,
                    buttonChangePassword(),
                  ],
                ),
              ),
            ),
          ),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        
          Icon(Icons.lock, color: AppColors.primaryColor),
          ConstantSpace.smallHorizontalSpacer,
          Text(
            'change_password'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget inputCurrentPassword(BuildContext context, controller) {
    return TextFieldInnerShadow(
      borderRadius: 16,
      controller: controller,
      hintText: 'current_password'.tr,
      prefixIcon: const Icon(Icons.lock),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'current_password_required'.tr;
        }
        return null;
      },
      width: MediaQuery.sizeOf(context).width * 0.82,
    );
  }

  Widget inputNewPassword(BuildContext context, controller) {
    return TextFieldInnerShadow(
      borderRadius: 16,
      controller: controller,
      hintText: 'new_password'.tr,
      prefixIcon: const Icon(Icons.lock),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'new_password_required'.tr;
        }
        return null;
      },
      width: MediaQuery.sizeOf(context).width * 0.82,
    );
  }

  Widget changePasswordInformation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'enter_new_password'.tr,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget buttonChangePassword() {
    return BoxNeumorphysm(
      onTap: controller.isLoadingChangePassword.value
          ? () {}
          : () async {
              final prefs = await SharedPreferences.getInstance();
              final userId = prefs.getString('userId');
              if (formKeyChangePassword.currentState!.validate()) {
                controller.changePassword(userId ?? '');
              }
              controller.currentPassword.clear();
              controller.newPassword.clear();
            },
      borderRadius: 12,
      borderColor: AppColors.background,
      borderWidth: 5,
      backgroundColor: AppColors.primaryColor,
      topLeftShadowColor: Colors.white,
      bottomRightShadowColor: const Color.fromARGB(255, 139, 204, 222),
      height: 60,
      width: 200,
      bottomRightOffset: const Offset(4, 4),
      topLeftOffset: const Offset(-4, -4),
      child: Center(
        child: Obx(() {
          return controller.isLoadingChangePassword.value
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: AppColors.background),
                )
              : Text(
                  'change_password'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.background,
                  ),
                );
        }),
      ),
    );
  }

  Widget buttonSaveProfile() {
    return BoxNeumorphysm(
      onTap: () async {
        if (controller.isLoadingUpdate.value) {
          return;
        }

        if (formKey.currentState?.validate() ?? false) {
          final prefs = await SharedPreferences.getInstance();
          final userId = prefs.getString('userId');

          if (userId != null && userId.isNotEmpty) {
            await controller.updateProfile(userId);
            controller.fetchUserProfile(userId);
          } else {
            Get.snackbar(
              'error'.tr,
              'user_id_not_found'.tr,
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            'validation_error'.tr,
            'check_required_fields'.tr,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      },
      borderRadius: 12,
      borderColor: AppColors.background,
      borderWidth: 5,
      backgroundColor: AppColors.primaryColor,
      topLeftShadowColor: Colors.white,
      bottomRightShadowColor: const Color.fromARGB(255, 139, 204, 222),
      height: 60,
      width: 200,
      bottomRightOffset: const Offset(4, 4),
      topLeftOffset: const Offset(-4, -4),
      child: Center(
        child: Obx(() {
          return controller.isLoadingUpdate.value
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: AppColors.background),
                )
              : Text(
                  'save_profile'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.background,
                  ),
                );
        }),
      ),
    );
  }

  Widget logoutButton() {
    return
      ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(),
        icon: Icon(Icons.logout),
        label: Text('logout'.tr),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
      );
 
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('confirm_logout'.tr),
        content: Text('are_you_sure_logout'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          ElevatedButton(
            onPressed: () {
              Get.back();
              authController.quickLogout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('logout'.tr, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
