import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/home/domain/entities/add_members.dart';
import 'package:test3/features/home/domain/entities/create_team.dart';
import 'package:test3/features/home/domain/usecase/add_members_usecase.dart';
import 'package:test3/features/home/domain/usecase/create_team_usecase.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';

class CreateTeamController extends GetxController {
  final CreateTeamUseCase _createTeamUseCase;
  final AddMembersUseCase _addMembersUseCase;

  CreateTeamController(this._createTeamUseCase, this._addMembersUseCase);

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxBool isHealthcare = false.obs;
  final RxBool isHousehold = false.obs;
  final RxBool isReferral = false.obs;
  final RxBool isBurial = false.obs;

  final RxList<String> selectedMembers = <String>[].obs;

  Future<void> createTeamWithMembers() async {
    if (!_validateForm()) return;
    print('selectedmemeber  :  ${selectedMembers.toList()}');

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = CreateTeamRequest(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        isHealthcareCleaningAndDisinfection: isHealthcare.value,
        isHouseholdCleaningAndDisinfection: isHousehold.value,
        isPatientsReferral: isReferral.value,
        isSafeAndDignifiedBurial: isBurial.value,
      );

      final createdTeam = await _createTeamUseCase.call(request);

      if (selectedMembers.isNotEmpty) {
        final addMembersRequest = AddMembersRequest(
          teamId: createdTeam.id,
          userId: selectedMembers.toList(),
        );
        await _addMembersUseCase.call(addMembersRequest);
      }

      _clearForm();
      Get.back();
      Get.snackbar(
        'success'.tr,
        'team_created_successfully'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: AppColors.background,
      );

      final homeController = Get.find<HomeController>();
     await homeController.fetchTeams();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void toggleMemberSelection(String userId) {
    if (selectedMembers.contains(userId)) {
      selectedMembers.remove(userId);
    } else {
      selectedMembers.add(userId);
    }
  }

  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      errorMessage.value = 'team_name_required'.tr;
      return false;
    }
    if (descriptionController.text.trim().isEmpty) {
      errorMessage.value = 'description_required'.tr;
      return false;
    }
    return true;
  }

  void _clearForm() {
    nameController.clear();
    descriptionController.clear();
    isHealthcare.value = false;
    isHousehold.value = false;
    isReferral.value = false;
    isBurial.value = false;
    selectedMembers.clear();
    errorMessage.value = '';
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
