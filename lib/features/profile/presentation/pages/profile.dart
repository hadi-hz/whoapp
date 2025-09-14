import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/core/theme/theme_controller.dart';
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
      _setStatusBarStyle();

      await controller.fetchUserProfile();
    });
  }

  void _setStatusBarStyle() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: isDark ? Colors.grey[900] : AppColors.primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: isDark
          ? theme.scaffoldBackgroundColor
          : AppColors.background,
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, child: bodyTitles(context)),
          Positioned(
            top: screenHeight < 700 ? screenHeight * 0.32 : screenHeight * 0.26,
            left: 0,
            right: 0,
            bottom: keyboardHeight, // تنظیم bottom با keyboard
            child: Container(
              width: screenWidth,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const ChangeLang(),
                        Obx(() {
                          final themeController = Get.find<ThemeController>();

                          return IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                            ),
                            icon: Icon(
                              themeController.isLightMode()
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                              color: AppColors.background,
                            ),
                            onPressed: () {
                              themeController.toggleTheme();
                            },
                          );
                        }),
                      ],
                    ),
                    ConstantSpace.smallVerticalSpacer,
                    userNameBox(context),
                    ConstantSpace.smallVerticalSpacer,
                    fullNameBox(context),
                    ConstantSpace.smallVerticalSpacer,
                    emailBox(context),
                    ConstantSpace.smallVerticalSpacer,
                    roleBox(context),
                    ConstantSpace.mediumVerticalSpacer,
                    changePasswordButton(context),
                    ConstantSpace.mediumVerticalSpacer,
                    Row(children: [logoutButton(context)]),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top:
                (screenHeight < 700
                    ? screenHeight * 0.32
                    : screenHeight * 0.26) -
                25,
            left: (screenWidth / 2) - 50,
            child: profileCircle(context),
          ),
        ],
      ),
    );
  }

  Widget bodyTitles(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final baseHeight = screenHeight < 700 ? 200.0 : 500.0;
    final logoSize = screenWidth < 400 ? 100.0 : 130.0;
    final fontSize = screenWidth < 400 ? 18.0 : 22.0;

    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: baseHeight + statusBarHeight,
      color: isDark ? theme.primaryColor : AppColors.primaryColor,
      child: Padding(
        padding: EdgeInsets.only(
          top: statusBarHeight + (screenHeight < 700 ? 16 : 32),
        ),
        child: Column(
          children: [
            if (screenHeight >= 700) ConstantSpace.largeVerticalSpacer,
            if (screenHeight >= 700) ConstantSpace.largeVerticalSpacer,
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
                        width: logoSize,
                        height: logoSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => animatedText(
                            controller.showHello.value,
                            _buildTitle(context, fontSize),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, double fontSize) {
    return Row(
      children: [
        ConstantSpace.mediumHorizontalSpacer,
        Flexible(
          child: Text(
            "world_health_organization".tr,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              color: AppColors.background,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
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

  // باقی متدها همان باقی می‌مانند...
  Widget userNameBox(BuildContext context) {
    final theme = Theme.of(context);

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
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget fullNameBox(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      return Row(
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
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget emailBox(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      return Row(
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
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  ConstantSpace.smallHorizontalSpacer,
                  controller.userInfo.value?.emailConfirmed == true
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.error, color: Colors.red),
                ],
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget roleBox(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      return Row(
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
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget profileCircle(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final file = controller.imageFile.value;
      final networkUrl = controller.userInfo.value?.profileImageUrl;
      return Stack(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? theme.cardColor
                  : const Color.fromARGB(255, 223, 221, 221),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: file != null
                  ? Image.file(file, fit: BoxFit.cover, width: 100, height: 100)
                  : (networkUrl != null && networkUrl.isNotEmpty
                        ? Image.network(
                            networkUrl,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                size: 50,
                                color: theme.iconTheme.color,
                              );
                            },
                          )
                        : Icon(
                            Icons.person,
                            size: 50,
                            color: theme.iconTheme.color,
                          )),
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
                border: Border.all(color: theme.cardColor, width: 2),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Container(
                      height: MediaQuery.of(context).size.height * 0.62,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(25),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person_add,
                                  color: AppColors.primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'edit_profile'.tr,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: Icon(
                                    Icons.close,
                                    color: theme.iconTheme.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 12,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                    30,
                              ),
                              child: SingleChildScrollView(
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      chooseImageProfile(context),
                                      ConstantSpace.mediumVerticalSpacer,
                                      inputName(context, controller.name),
                                      ConstantSpace.mediumVerticalSpacer,
                                      inputLastName(
                                        context,
                                        controller.lastName,
                                      ),
                                      ConstantSpace.largeVerticalSpacer,
                                      buttonSaveProfile(context),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).whenComplete(() {
                    controller.name.clear();
                    controller.lastName.clear();
                    controller.imageFile.value = null;
                  });
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget chooseImageProfile(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        Obx(
          () => Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(width: 3, color: AppColors.primaryColor),
              shape: BoxShape.circle,
              color: isDark
                  ? theme.cardColor
                  : const Color.fromARGB(255, 223, 221, 221),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: controller.imageFile.value == null
                  ? Icon(Icons.person, size: 50, color: theme.iconTheme.color)
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
              border: Border.all(color: theme.cardColor, width: 2),
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

  Widget inputName(BuildContext context, controller) {
    return TextFieldInnerShadow(
      borderRadius: 16,
      controller: controller,
      hintText: 'name'.tr,
      prefixIcon: const Icon(Icons.person),
      validator: (p0) => null,
      width: MediaQuery.sizeOf(context).width * 0.82,
    );
  }

  Widget inputLastName(BuildContext context, controller) {
    return TextFieldInnerShadow(
      borderRadius: 16,
      controller: controller,
      hintText: 'lastname'.tr,
      prefixIcon: const Icon(Icons.person),
      validator: (p0) => null,
      width: MediaQuery.sizeOf(context).width * 0.82,
    );
  }

  Widget changePasswordButton(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 30,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKeyChangePassword,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: context.width * 0.28,
                        child: Divider(
                          color: theme.dividerColor,
                          thickness: 4,
                          radius: const BorderRadius.all(Radius.circular(22)),
                        ),
                      ),
                      ConstantSpace.mediumVerticalSpacer,
                      changePasswordInformation(context),
                      ConstantSpace.largeVerticalSpacer,
                      inputCurrentPassword(context, controller.currentPassword),
                      ConstantSpace.mediumVerticalSpacer,
                      inputNewPassword(context, controller.newPassword),
                      ConstantSpace.largeVerticalSpacer,
                      buttonChangePassword(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
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

  Widget changePasswordInformation(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'enter_new_password'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }

  Widget buttonChangePassword(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BoxNeumorphysm(
      onTap: controller.isLoadingChangePassword.value
          ? () {}
          : () async {
              final prefs = await SharedPreferences.getInstance();
              final userId = prefs.getString('userId');
              if (formKeyChangePassword.currentState!.validate()) {
                controller.changePassword(userId ?? '');
              }
            },
      borderRadius: 12,
      borderColor: isDark ? theme.dividerColor : AppColors.background,
      borderWidth: 5,
      backgroundColor: AppColors.primaryColor,
      topLeftShadowColor: isDark ? theme.highlightColor : Colors.white,
      bottomRightShadowColor: isDark
          ? theme.shadowColor.withOpacity(0.3)
          : const Color.fromARGB(255, 139, 204, 222),
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
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : Text(
                  'change_password'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onPrimary,
                  ),
                );
        }),
      ),
    );
  }

  Widget buttonSaveProfile(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BoxNeumorphysm(
      onTap: () async {
        if (controller.isLoadingUpdate.value) return;
        if (formKey.currentState?.validate() ?? false) {
          final prefs = await SharedPreferences.getInstance();
          final userId = prefs.getString('userId');
          if (userId != null && userId.isNotEmpty) {
            await controller.updateProfile(userId);
            controller.userInfo.value = null;
            controller.fetchUserProfile();
          }
        }
      },
      borderRadius: 12,
      borderColor: isDark ? theme.dividerColor : AppColors.background,
      borderWidth: 5,
      backgroundColor: AppColors.primaryColor,
      topLeftShadowColor: isDark ? theme.highlightColor : Colors.white,
      bottomRightShadowColor: isDark
          ? theme.shadowColor.withOpacity(0.3)
          : const Color.fromARGB(255, 139, 204, 222),
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
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : Text(
                  'save_profile'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onPrimary,
                  ),
                );
        }),
      ),
    );
  }

  Widget logoutButton(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.logout, color: Colors.white),
            const SizedBox(width: 8),
            Text('logout'.tr, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);

    Get.dialog(
      AlertDialog(
        backgroundColor: theme.dialogBackgroundColor,
        title: Text(
          'confirm_logout'.tr,
          style: TextStyle(color: theme.textTheme.titleLarge?.color),
        ),
        content: Text(
          'are_you_sure_logout'.tr,
          style: TextStyle(color: theme.textTheme.bodyMedium?.color),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            ),
          ),
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
