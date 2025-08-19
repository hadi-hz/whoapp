import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/add_report/presentation/controller/add_report_controller.dart';
import 'package:test3/features/add_report/presentation/pages/map.dart';
import 'package:test3/features/auth/presentation/pages/widgets/box_neumorphysm.dart';
import 'package:test3/features/auth/presentation/pages/widgets/inner_shadow_container.dart';
import 'package:test3/features/auth/presentation/pages/widgets/text_filed.dart';

class AddReportPage extends StatelessWidget {
  AddReportPage({super.key});

  final AddReportController controller = Get.find<AddReportController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsetsDirectional.only(top: 60, start: 20, end: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              pickerImage(context),

              ConstantSpace.mediumVerticalSpacer,
              dropDownHealth(context),
              ConstantSpace.smallVerticalSpacer,
              description(context, controller.description),
              ConstantSpace.xLargeVerticalSpacer,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [buttonSubmitReport(), buttonPickLocation(context)],
              ),
            ],
          ),
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
              title: const Text('Take photo'),
              onTap: () {
                Navigator.of(context).pop();
                controller.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Choose from gallery'),
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

  Widget description(BuildContext context, controller) {
    return TextFieldInnerShadow(
      borderRadius: 16,
      controller: controller,
      height: context.height * 0.2,
      maxLine: 5,
      hintText: "description",
      validator: (p0) {
        return null;
      },
      width: MediaQuery.sizeOf(context).width,
    );
  }

  Widget pickerImage(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showPickOptionsDialog(context),
          child: InnerShadowContainer(
            width: context.width,
            height: 200,
            borderRadius: 8,
            blur: 8,
            offset: const Offset(5, 5),
            shadowColor: AppColors.innershadow,
            backgroundColor: AppColors.backgroundColor,
            isShadowTopLeft: true,
            isShadowTopRight: true,
            child: Container(
              color: AppColors.backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, size: 50, color: Colors.black54),
                  ConstantSpace.smallVerticalSpacer,
                  Text(
                    'Take Photo / Choose image',
                    style: TextStyle(
                      color: AppColors.borderColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ConstantSpace.smallVerticalSpacer,
        Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: controller.pickedImages
                  .map(
                    (img) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(img.path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget dropDownHealth(BuildContext context) {
    return InnerShadowContainer(
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
                child: PopupMenuButton<String>(
                  constraints: BoxConstraints(minWidth: context.width * 0.9),
                  onSelected: (value) {
                    controller.changeService(value);
                  },
                  itemBuilder: (context) {
                    return controller.services
                        .map(
                          (service) => PopupMenuItem<String>(
                            value: service,
                            child: Text(service),
                          ),
                        )
                        .toList();
                  },
                  offset: const Offset(12, 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.selectedServiceIndex.value == -1
                            ? "Select Health Service"
                            : controller.services[controller
                                  .selectedServiceIndex
                                  .value],
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
    );
  }

  Widget buttonSubmitReport() {
    return BoxNeumorphysm(
      onTap: () {
        print('Submit');
        controller.submitReport(); 
      },
      borderRadius: 12,
      borderWidth: 5,
      backgroundColor: AppColors.primaryColor,
      topLeftShadowColor: Color.fromARGB(255, 138, 137, 137),
      bottomRightShadowColor: Color.fromARGB(255, 162, 162, 162),
      height: 60,
      width: 150,
      bottomRightOffset: const Offset(4, 4),
      topLeftOffset: const Offset(-4, -4),
      child: Center(
        child: Text(
          "Submit Report",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.backgroundColor,
          ),
        ),
      ),
    );
  }

  Widget buttonPickLocation(BuildContext context) {
    return BoxNeumorphysm(
      onTap: () async {
        final LatLng? result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MapPickerPage()),
        );

        if (result != null) {
          controller.selectedLat.value = result.latitude;
          controller.selectedLng.value = result.longitude;
          print("Selected: ${result.latitude}, ${result.longitude}");
        }
      },
      borderRadius: 12,
      borderWidth: 5,
      backgroundColor: AppColors.primaryColor,
      topLeftShadowColor: Color.fromARGB(255, 138, 137, 137),
      bottomRightShadowColor: Color.fromARGB(255, 162, 162, 162),
      height: 60,
      width: 150,
      bottomRightOffset: const Offset(4, 4),
      topLeftOffset: const Offset(-4, -4),
      child: const Center(
        child: Text(
          "Pick Location",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
