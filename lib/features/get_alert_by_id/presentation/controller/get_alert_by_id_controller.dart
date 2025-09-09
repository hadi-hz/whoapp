import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/get_alert-by_id.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/teams.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/assign_team_usecase.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/get_alert_by_id_usecase.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/get_team_by_alert_type.dart';
import 'package:url_launcher/url_launcher.dart';

class AlertDetailController extends GetxController {
  final GetAlertDetailUseCase getAlertDetailUseCase;
  final GetTeamByAlertType getTeamByAlertType;
  final AssignTeamUseCase assignTeamUseCase;

  AlertDetailController({
    required this.getAlertDetailUseCase,
    required this.getTeamByAlertType,
    required this.assignTeamUseCase,
  });

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  Rxn<AlertDetailEntity> alertDetail = Rxn<AlertDetailEntity>();

  var isLoadingTeam = false.obs;
  var errorMessageTeam = ''.obs;
  var teams = <TeamsEntity>[].obs;

  var isAssigning = false.obs;
  var assignErrorMessage = ''.obs;

  Rxn<TeamsEntity> selectedTeam = Rxn<TeamsEntity>();

  void clearSelectedTeam() {
    selectedTeam.value = null;
  }

  var userRole = ''.obs;

  Future<void> openDirections(LatLng destination) async {
  if (Platform.isIOS) {
    await _openDirectionsIOS(destination);
  } else {
    await _openDirectionsAndroid(destination);
  }
}

Future<void> _openDirectionsIOS(LatLng destination) async {

  final googleMapsUrl = 'comgooglemaps://?daddr=${destination.latitude},${destination.longitude}&directionsmode=driving';
  
  if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
    await launchUrl(Uri.parse(googleMapsUrl));
    return;
  }
  

  final appleMapsUrl = 'maps://app?daddr=${destination.latitude},${destination.longitude}';
  
  if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
    await launchUrl(Uri.parse(appleMapsUrl));
    return;
  }
  
 
  await _openWebMaps(destination);
}

Future<void> _openDirectionsAndroid(LatLng destination) async {
  
  final googleMapsUrl = 'google.navigation:q=${destination.latitude},${destination.longitude}';
  
  if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
    await launchUrl(Uri.parse(googleMapsUrl));
    return;
  }
  
  // Fallback to web
  await _openWebMaps(destination);
}

Future<void> _openWebMaps(LatLng destination) async {
  final webUrl = 'https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}';
  
  if (await canLaunchUrl(Uri.parse(webUrl))) {
    await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not open maps';
  }
}

  Future<void> fetchTeamByAlertType(int alertType) async {
    isLoadingTeam.value = true;
    errorMessageTeam.value = "";

    final result = await getTeamByAlertType(alertType);
    print('result team : ${result}');

    result.fold(
      (error) => errorMessageTeam.value = error,
      (teamsList) => teams.value = teamsList,
    );

    isLoadingTeam.value = false;
  }

  Future<void> fetchAlertDetail(String alertId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedUserId = prefs.getString('userId');
    final String? savedRole = prefs.getString('role');
    userRole.value = savedRole ?? '';
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await getAlertDetailUseCase(alertId, savedUserId ?? '');
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
          print("alertDetail.value : ${alertDetail.value?.team?.id}");
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
        return userRole.value == 'Admin' ? Colors.red : Colors.green;
      case 1:
        return userRole.value == 'Admin' ? Colors.orange : Colors.blue;
      case 2:
        return userRole.value == 'Admin'
            ? const Color.fromARGB(255, 208, 189, 13)
            : userRole.value == 'ServiceProvider'
            ? Colors.red
            : Colors.orange;
      case 3:
        return userRole.value == 'Admin'
            ? const Color.fromARGB(255, 208, 189, 13)
            : userRole.value == 'ServiceProvider'
            ? const Color.fromARGB(255, 208, 189, 13)
            : Colors.purple;
      case 4:
        return userRole.value == 'Admin'
            ? const Color.fromARGB(255, 208, 189, 13)
            : userRole.value == 'ServiceProvider'
            ? Colors.orange
            : Colors.teal;
      case 5:
        return userRole.value == 'Admin'
            ? Colors.orange
            : userRole.value == 'ServiceProvider'
            ? const Color.fromARGB(255, 208, 189, 13)
            : const Color.fromARGB(255, 208, 189, 13);
      case 6:
        return userRole.value == 'Admin'
            ? Colors.green
            : userRole.value == 'ServiceProvider'
            ? Colors.green
            : Colors.red;
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

  Future<bool> assignTeamToAlert({
    required String alertId,
    required String teamId,
    required String userId,
  }) async {
    isAssigning.value = true;
    assignErrorMessage.value = '';

    final result = await assignTeamUseCase(
      alertId: alertId,
      teamId: teamId,
      userId: userId,
    );

    isAssigning.value = false;

    return result.fold(
      (error) {
        assignErrorMessage.value = error;
        Get.snackbar(
          'error'.tr,
          error,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      },
      (assignResult) {
        Get.snackbar(
          'success'.tr,
          assignResult.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        return true;
      },
    );
  }

  void clearAssignError() {
    assignErrorMessage.value = '';
  }
}
