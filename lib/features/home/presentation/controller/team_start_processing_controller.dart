import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/features/home/domain/entities/team_start_processing.dart';
import 'package:test3/features/home/domain/usecase/team_start_processing.dart';

class TeamStartProcessingController extends GetxController {
  final TeamStartProcessingUseCase _teamStartProcessingUseCase;

  TeamStartProcessingController(this._teamStartProcessingUseCase);

  final RxBool isStartingProcess = false.obs;
  final RxString errorMessage = ''.obs;

  Future<bool> teamStartProcessing({
    required String alertId,
    required String userId,
  }) async {
    try {
      isStartingProcess.value = true;
      errorMessage.value = '';

      final request = TeamStartProcessingRequest(
        alertId: alertId,
        userId: userId,
      );

      final response = await _teamStartProcessingUseCase.call(request);

      Get.snackbar(
        'success'.tr,
        response.message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'error'.tr,
        'Failed to start processing: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isStartingProcess.value = false;
    }
  }
}
