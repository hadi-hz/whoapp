import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/visited_by_team_member.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/visited_by_team_member_usecase.dart';

class VisitedByTeamMemberController extends GetxController {
  final VisitedByTeamMemberUseCase _visitedByTeamMemberUseCase;

  VisitedByTeamMemberController(this._visitedByTeamMemberUseCase);

  final RxBool isMarking = false.obs;
  final RxString errorMessage = ''.obs;

  Future<bool> markAsVisitedByTeamMember({
    required String alertId,
    required String userId,
  }) async {
    try {
      isMarking.value = true;
      errorMessage.value = '';

      final request = VisitedByTeamMemberRequest(
        alertId: alertId,
        userId: userId,
      );

      final response = await _visitedByTeamMemberUseCase.call(request);

      // Get.snackbar(
      //   'success'.tr,
      //   response.message,
      //   snackPosition: SnackPosition.TOP,
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      // );

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      // Get.snackbar(
      //   'error'.tr,
      //   'Failed to mark as visited: $e',
      //   snackPosition: SnackPosition.TOP,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
      return false;
    } finally {
      isMarking.value = false;
    }
  }
}
