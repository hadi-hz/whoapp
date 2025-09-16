import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/features/home/domain/entities/admin_close_alert_response.dart';
import 'package:test3/features/home/domain/usecase/admin_close_alert_usecase.dart';
import 'package:test3/features/home/presentation/controller/get_alert_controller.dart';

class AdminCloseAlertController extends GetxController {
  final CloseAlertUseCase closeAlertUseCase;

  AdminCloseAlertController({required this.closeAlertUseCase});

  final RxBool isLoading = false.obs;

  Future<void> closeAlert(String alertId, String userId) async {
    try {
      isLoading.value = true;

      final request = AdminCloseAlertRequest(alertId: alertId, userId: userId);

      final result = await closeAlertUseCase.call(request);

      result.fold(
        (error) {
          Get.snackbar(
            'error'.tr,
            error,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
        (response) {
          Get.snackbar(
            'success'.tr,
            'Report Closed',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          final alertController = Get.find<AlertListController>();
          alertController.refreshAlerts();
        },
      );
    } finally {
      isLoading.value = false;
    }
  }
}
