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
import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/home/presentation/pages/widgets/reports.dart';
import 'package:test3/features/profile/presentation/pages/profile.dart';

class AnimatedBottomNav extends StatelessWidget {
  AnimatedBottomNav({super.key});

  final HomeController homeController = Get.find<HomeController>();
  final AddReportController controller = Get.find<AddReportController>();
  final authController = Get.find<AuthController>();

  final iconList = <IconData>[Icons.person, Icons.list_alt_rounded];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
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
                          SizedBox(
                            width: context.width * 0.28,
                            child: Divider(
                              color: AppColors.textColor,
                              thickness: 4,
                              radius: BorderRadius.all(Radius.circular(22)),
                            ),
                          ),
                          ConstantSpace.largeVerticalSpacer,
                          pickerImage(context),

                          ConstantSpace.mediumVerticalSpacer,
                          dropDownHealth(context),
                          ConstantSpace.smallVerticalSpacer,
                          patientName(context, controller.patientName),
                          ConstantSpace.smallVerticalSpacer,
                          description(context, controller.description),
                          ConstantSpace.xLargeVerticalSpacer,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buttonSubmitReport(),
                              buttonPickLocation(context),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
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

  void _showPickOptionsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text('take_photo'.tr),
              onTap: () {
                Navigator.of(context).pop();
                controller.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: Text('choose_from_gallery'.tr),
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

  Widget description(BuildContext context, TextEditingController controller) {
    return TextFieldInnerShadow(
      borderRadius: 16,
      controller: controller,
      maxLine: 5,
      hintText: 'description'.tr,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'enter_description'.tr;
        }
        return null;
      },
      width: MediaQuery.sizeOf(context).width,
    );
  }

  Widget pickerImage(BuildContext context) {
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              children: controller.pickedImages
                  .asMap()
                  .entries
                  .map(
                    (entry) => Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.textColor,
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
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
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
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget dropDownHealth(BuildContext context) {
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
          InnerShadowContainer(
            width: context.width,
            height: 60,
            borderRadius: 8,
            blur: 8,
            offset: const Offset(5, 5),
            shadowColor: AppColors.innershadow,
            backgroundColor: AppColors.backgroundColor,
            isShadowTopLeft: true,
            isShadowTopRight: true,
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
                        onSelected: (index) {
                          authController.changeAlertType(index);
                          field.didChange(index);
                        },
                        itemBuilder: (context) {
                          return healthServices
                              .map(
                                (service) => PopupMenuItem<int>(
                                  value: service['value'],
                                  child: Text(service['name']),
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
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.arrow_drop_down),
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

  Widget buttonSubmitReport() {
    return BoxNeumorphysm(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        final savedUserId = prefs.getString('userId') ?? '';
        if (_formKey.currentState!.validate()) {
          await controller.submitReport(
            authController.selectedAlertIndex.value,
          );
        }
        homeController.fetchAlerts(
          userId: savedUserId,
          sortDescending: true,
          page: 1,
          pageSize: 100,
        );
      },
      borderRadius: 12,
      borderWidth: 5,
      backgroundColor: AppColors.primaryColor,
      topLeftShadowColor: const Color.fromARGB(255, 199, 226, 255),
      bottomRightShadowColor: const Color.fromARGB(255, 181, 222, 243),
      height: 60,
      width: 150,
      bottomRightOffset: const Offset(4, 4),
      topLeftOffset: const Offset(-4, -4),
      child: Center(
        child: Obx(
          () => controller.isLoading.value
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.background,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'submit_report'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.background,
                  ),
                ),
        ),
      ),
    );
  }

  Widget buttonPickLocation(BuildContext context) {
    return Obx(() {
      return BoxNeumorphysm(
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
          } else {
            print('no_location_selected'.tr);
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
        width: 150,
        bottomRightOffset: const Offset(4, 4),
        topLeftOffset: const Offset(-4, -4),
        child: Center(
          child: Row(
            children: [
              controller.selectedLat.value != 0.0
                  ? Icon(Icons.check_circle, color: AppColors.background)
                  : Icon(Icons.location_on, color: AppColors.background),
              SizedBox(width: 8),
              Text(
                'location'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget patientName(BuildContext context, TextEditingController controller) {
    return TextFieldInnerShadow(
      borderRadius: 16,
      controller: controller,
      maxLine: 1,
      hintText: 'patient_name'.tr,
      validator: (value) {},
      width: MediaQuery.sizeOf(context).width,
    );
  }
}
