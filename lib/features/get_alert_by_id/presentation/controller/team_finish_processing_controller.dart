import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/team_finish_processing.dart';

class TeamFinishProcessingController extends GetxController {
  final TeamFinishProcessingUseCase useCase;
  
  TeamFinishProcessingController(this.useCase);

  final RxBool isFinishingProcess = false.obs;
  final RxString errorMessage = ''.obs;
  final TextEditingController descriptionController = TextEditingController();
  final RxList<File> selectedImages = <File>[].obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      selectedImages.addAll(images.map((image) => File(image.path)));
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to pick images',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<bool> teamFinishProcessing({
    required String alertId,
    required String userId,
  }) async {
    try {
      isFinishingProcess.value = true;
      errorMessage.value = '';

      List<String> imagePaths = selectedImages.map((file) => file.path).toList();

      await useCase.call(
        alertId: alertId,
        userId: userId,
        description: descriptionController.text.trim(),
        files: imagePaths,
      );

      Get.snackbar(
        'success'.tr,
        'Processing finished successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      descriptionController.clear();
      selectedImages.clear();
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'error'.tr,
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isFinishingProcess.value = false;
    }
  }

  bool validateForm() {
    if (descriptionController.text.trim().isEmpty) {
      errorMessage.value = 'description_required'.tr;
      return false;
    }
    errorMessage.value = '';
    return true;
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }



  Future<void> pickImageFromCamera() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
  if (pickedFile != null) {
    selectedImages.add(File(pickedFile.path));
  }
}

Future<void> pickImageFromGallery() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    selectedImages.add(File(pickedFile.path));
  }
}
}