import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/add_report/presentation/controller/add_report_controller.dart';
import 'package:test3/features/add_report/presentation/pages/map.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/auth/presentation/pages/widgets/box_neumorphysm.dart';
import 'package:test3/features/auth/presentation/pages/widgets/inner_shadow_container.dart';
import 'package:test3/features/auth/presentation/pages/widgets/text_filed.dart';
import 'package:test3/features/home/presentation/controller/get_alert_controller.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';

import 'package:test3/features/home/presentation/pages/widgets/reports.dart';
import 'package:test3/features/profile/presentation/pages/profile.dart';

class AnimatedBottomNavDoctor extends StatelessWidget {
  AnimatedBottomNavDoctor({super.key});

  final HomeController homeController = Get.find<HomeController>();
  final AddReportController controller = Get.find<AddReportController>();
  final AlertListController alertController = Get.find<AlertListController>();
  final authController = Get.find<AuthController>();

  final iconList = <IconData>[Icons.person, Icons.list_alt_rounded];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Obx(() {
        return IndexedStack(
          index: homeController.selectedIndex.value,
          children: [ProfilePage(), ReportsPage()],
        );
      }),
      floatingActionButton: SizedBox(
        width: 65,
        height: 65,
        child: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            Get.bottomSheet(
              Container(
                height: MediaQuery.of(context).size.height * 0.68,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(
                          isDark ? 0.2 : 0.1,
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add_circle, color: AppColors.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'add_report'.tr,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: Icon(
                              Icons.close,
                              color: isDark ? Colors.white70 : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                          bottom: 40,
                          start: 20,
                          end: 20,
                          top: 12,
                        ),
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                pickerImage(context, isDark),
                                ConstantSpace.mediumVerticalSpacer,
                                dropDownHealth(context, isDark),
                                ConstantSpace.smallVerticalSpacer,
                                patientName(
                                  context,
                                  controller.patientName,
                                  isDark,
                                ),
                                ConstantSpace.smallVerticalSpacer,
                                description(
                                  context,
                                  controller.description,
                                  isDark,
                                ),
                                ConstantSpace.xLargeVerticalSpacer,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(child: buttonSubmitReport()),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: buttonPickLocation(context),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
            );
          },
          child: const Icon(Icons.add_circle, size: 42, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
        () => AnimatedBottomNavigationBar(
          height: 70,
          iconSize: 28,
          icons: iconList,
          activeIndex: homeController.selectedIndex.value,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.sharpEdge,
          onTap: homeController.changePage,
          backgroundColor: AppColors.primaryColor,
          activeColor: AppColors.backgroundColor,
          inactiveColor: AppColors.backgroundColor.withOpacity(0.6),
          leftCornerRadius: 12,
          rightCornerRadius: 12,
        ),
      ),
    );
  }

  Widget buttonSubmitReport() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = MediaQuery.of(context).size.width;
        double buttonWidth = screenWidth > 400 ? 170 : screenWidth * 0.4;

        return Obx(
          () => BoxNeumorphysm(
            backgroundColor: AppColors.primaryColor,
            width: buttonWidth,
            height: 60,
            borderRadius: 12,
            borderWidth: 5,
            topLeftShadowColor: const Color.fromARGB(255, 199, 226, 255),
            bottomRightShadowColor: const Color.fromARGB(255, 181, 222, 243),
            bottomRightOffset: const Offset(4, 4),
            topLeftOffset: const Offset(-4, -4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                controller.isLoading.value
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.background,
                        ),
                      )
                    : Flexible(
                        child: Text(
                          'submit_report'.tr,
                          style: TextStyle(
                            fontSize: screenWidth > 400 ? 16 : 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
              ],
            ),
            onTap: () async {
              String? validationError = _validateForm();
              if (validationError != null) {
                Get.snackbar(
                  'validation_error'.tr,
                  validationError,
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(12),
                  borderRadius: 8,
                );
                return;
              }

              if (_formKey.currentState!.validate()) {
                final prefs = await SharedPreferences.getInstance();
                final savedUserId = prefs.getString('userId') ?? '';

                await controller.submitReport(
                  authController.selectedAlertIndex.value,
                );

                await _refreshAlerts(savedUserId);
              }
            },
          ),
        );
      },
    );
  }

  Future<void> _refreshAlerts(String userId) async {
    alertController.selectedUserId.value = userId;
    alertController.sortDescending.value = true;
    alertController.currentPage.value = 1;
    alertController.pageSize.value = 100;

    await alertController.loadAlerts();
  }

  void _showPickOptionsDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? Colors.grey[850] : Colors.white,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: isDark ? Colors.white70 : Colors.black,
              ),
              title: Text(
                'take_photo'.tr,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              onTap: () {
                Navigator.of(context).pop();
                controller.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo,
                color: isDark ? Colors.white70 : Colors.black,
              ),
              title: Text(
                'choose_from_gallery'.tr,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              onTap: () {
                Navigator.of(context).pop();
                controller.pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget description(
    BuildContext context,
    TextEditingController controller,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.grey[800] : Colors.white,
        border: Border.all(
          color: isDark ? Colors.grey[600]! : AppColors.borderColor,
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: 5,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: 'description'.tr,
          hintStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: isDark ? Colors.grey[800] : Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'enter_description'.tr;
          }
          return null;
        },
      ),
    );
  }

  Widget pickerImage(BuildContext context, bool isDark) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(14),
              backgroundColor: AppColors.primaryColor,
            ),
            onPressed: () => _showPickOptionsDialog(context),
            child: Icon(
              Icons.add_a_photo_rounded,
              size: 24,
              color: AppColors.background,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.pickedImages.length,
                separatorBuilder: (context, index) => SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final entry = MapEntry(index, controller.pickedImages[index]);
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark
                                ? Colors.grey[600]!
                                : AppColors.textColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(entry.value.path),
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -2,
                        right: -2,
                        child: GestureDetector(
                          onTap: () => controller.removeImage(entry.key),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dropDownHealth(BuildContext context, bool isDark) {
    final List<Map<String, dynamic>> healthServices = [
      {'value': 0, 'name': 'healthcare_cleaning'.tr},
      {'value': 1, 'name': 'household_cleaning'.tr},
      {'value': 2, 'name': 'patient_referral'.tr},
      {'value': 3, 'name': 'safe_burial'.tr},
    ];

    return FormField<int>(
      validator: (value) {
        if (authController.selectedAlertIndex.value == -1) {
          return 'select_health_service'.tr;
        }
        return null;
      },
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.width,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isDark ? Colors.grey[800] : AppColors.backgroundColor,
              border: Border.all(
                color: isDark ? Colors.grey[600]! : AppColors.borderColor,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : AppColors.innershadow.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: PopupMenuButton<int>(
                        constraints: BoxConstraints(
                          minWidth: context.width * 0.9,
                        ),
                        color: isDark ? Colors.grey[800] : Colors.white,
                        onSelected: (index) {
                          authController.changeAlertType(index);
                          field.didChange(index);
                        },
                        itemBuilder: (context) {
                          return healthServices
                              .map(
                                (service) => PopupMenuItem<int>(
                                  value: service['value'],
                                  child: Text(
                                    service['name'],
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              )
                              .toList();
                        },
                        offset: const Offset(12, 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              authController.selectedAlertIndex.value == -1
                                  ? 'select_health_service_label'.tr
                                  : healthServices.firstWhere(
                                      (service) =>
                                          service['value'] ==
                                          authController
                                              .selectedAlertIndex
                                              .value,
                                      orElse: () => {'name': 'unknown'.tr},
                                    )['name'],
                              style: TextStyle(
                                fontSize: 16,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: isDark ? Colors.white70 : Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (field.hasError)
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 4),
              child: Text(
                field.errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  String? _validateForm() {
    if (controller.selectedLat.value == 0.0 ||
        controller.selectedLng.value == 0.0) {
      return 'no_location_selected'.tr;
    }

    if (controller.description.text.trim().isEmpty) {
      return 'enter_description'.tr;
    }

    if (authController.selectedAlertIndex.value == -1) {
      return 'select_health_service'.tr;
    }

    return null;
  }

  Widget buttonPickLocation(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = MediaQuery.of(context).size.width;
        double buttonWidth = screenWidth > 400 ? 170 : screenWidth * 0.4;

        return Obx(
          () => BoxNeumorphysm(
            onTap: () async {
              final LatLng? result = await Get.to<LatLng>(
                () => MapPickerPage(
                  userLat: controller.currentLatGps.value,
                  userLng: controller.currentLngGps.value,
                ),
              );

              if (result != null) {
                controller.selectedLat.value = result.latitude;
                controller.selectedLng.value = result.longitude;
              }
            },
            borderRadius: 12,
            borderWidth: 5,
            backgroundColor: controller.selectedLat.value != 0.0
                ? Colors.green
                : AppColors.primaryColor,
            topLeftShadowColor: const Color.fromARGB(255, 199, 226, 255),
            bottomRightShadowColor: const Color.fromARGB(255, 181, 222, 243),
            height: 60,
            width: buttonWidth,
            bottomRightOffset: const Offset(4, 4),
            topLeftOffset: const Offset(-4, -4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                controller.selectedLat.value != 0.0
                    ? Icon(Icons.check_circle, color: AppColors.background)
                    : Icon(Icons.location_on, color: AppColors.background),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'location'.tr,
                    style: TextStyle(
                      fontSize: screenWidth > 400 ? 16 : 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget patientName(
    BuildContext context,
    TextEditingController controller,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.grey[800] : Colors.white,
        border: Border.all(
          color: isDark ? Colors.grey[600]! : AppColors.borderColor,
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: 'patient_name'.tr,
          hintStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: isDark ? Colors.grey[800] : Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        validator: (value) {},
      ),
    );
  }
}
