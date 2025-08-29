import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/update_by_admin.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/update_by_admin.dart';

class UpdateAlertByAdminController extends GetxController {
  final UpdateAlertByAdminUseCase _updateAlertByAdminUseCase;

  UpdateAlertByAdminController(this._updateAlertByAdminUseCase);

  final RxBool isUpdating = false.obs;
  final RxString errorMessage = ''.obs;
  final descriptionController = TextEditingController();

  Future<bool> updateAlertByAdmin({
    required String alertId,
    required String description,
    required String userId,
  }) async {
    try {
      isUpdating.value = true;
      errorMessage.value = '';

      final request = UpdateAlertByAdminRequest(
        alertId: alertId,
        description: description,
        userId: userId,
      );

      final response = await _updateAlertByAdminUseCase.call(request);

      Get.snackbar(
        'success'.tr,
        response.message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      descriptionController.clear();
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'error'.tr,
        'Failed to update alert: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  bool validateDescription() {
    if (descriptionController.text.trim().isEmpty) {
      errorMessage.value = 'description_required'.tr;
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}