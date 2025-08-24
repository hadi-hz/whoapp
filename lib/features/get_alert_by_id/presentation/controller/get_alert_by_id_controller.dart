
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/get_alert-by_id.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/get_alert_by_id_usecase.dart';


class AlertDetailController extends GetxController {
  final GetAlertDetailUseCase getAlertDetailUseCase;

  AlertDetailController({required this.getAlertDetailUseCase});

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  Rxn<AlertDetailEntity> alertDetail = Rxn<AlertDetailEntity>();

  Future<void> fetchAlertDetail(String alertId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';


      final result = await getAlertDetailUseCase(alertId);
      print('result result : ${result}');
      
      result.fold(
        (failure) {
          errorMessage.value = failure;
          Get.snackbar(
            'error'.tr,
            failure,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
        (data) {
          alertDetail.value = data;
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String getStatusName(int status) {
    switch (status) {
      case 0:
        return 'initial'.tr;
      case 1:
        return 'visited_by_admin'.tr;
      case 2:
        return 'assigned_to_team'.tr;
      case 3:
        return 'visited_by_team_member'.tr;
      case 4:
        return 'team_start_processing'.tr;
      case 5:
        return 'team_finish_processing'.tr;
      case 6:
        return 'admin_close'.tr;
      default:
        return 'Unknown';
    }
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.teal;
      case 5:
        return Colors.yellow;
      case 6:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  String getAlertTypeName(int alertType) {
    switch (alertType) {
      case 0:
        return 'healthcare_cleaning'.tr;
      case 1:
        return 'household_cleaning'.tr;
      case 2:
        return 'patient_referral'.tr;
      case 3:
        return 'safe_burial'.tr;
      default:
        return 'Unknown';
    }
  }
}