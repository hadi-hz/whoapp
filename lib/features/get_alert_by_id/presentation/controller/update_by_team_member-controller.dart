import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/update_by_team_member.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/update_by_team_member.dart';

class UpdateAlertByTeamMemberController extends GetxController {
  final UpdateAlertByTeamMemberUseCase _updateAlertByTeamMemberUseCase;

  UpdateAlertByTeamMemberController(this._updateAlertByTeamMemberUseCase);

  final RxBool isUpdating = false.obs;
  final RxString errorMessage = ''.obs;
  final descriptionController = TextEditingController();

  Future<bool> updateAlertByTeamMember({
    required String alertId,
    required String description,
    required String userId,
  }) async {
    try {
      isUpdating.value = true;
      errorMessage.value = '';

      final request = UpdateAlertByTeamMemberRequest(
        alertId: alertId,
        description: description,
        userId: userId,
      );

      final response = await _updateAlertByTeamMemberUseCase.call(request);

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

  bool validateForm() {
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
