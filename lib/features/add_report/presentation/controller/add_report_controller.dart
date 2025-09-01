import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/core/network/db_helper.dart';
import 'package:test3/features/add_report/data/model/alert_model.dart';
import 'package:test3/features/add_report/domain/repositories/alert_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';

class AddReportController extends GetxController {
  final AlertRepository repository;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  var offlineReportsCount = 0.obs;
  

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  var isConnected = false.obs;

  AddReportController(this.repository);

  var currentLatGps = 0.0.obs;
  var currentLngGps = 0.0.obs;
  var isOfflineMode = false.obs;

  var selectedLat = 0.0.obs;
  var selectedLng = 0.0.obs;

  final TextEditingController description = TextEditingController();
  final TextEditingController patientName = TextEditingController();

  RxList<XFile> pickedImages = <XFile>[].obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    checkOfflineReports();
    _initConnectivityListener();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

 
  void _initConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      bool hasConnection = !result.contains(ConnectivityResult.none);
      isConnected.value = hasConnection;
      
  
      if (hasConnection && offlineReportsCount.value > 0) {
        syncOfflineReports();
      }
    });
  }

  List<File> convertXFilesToFiles(List<XFile> xFiles) {
    return xFiles.map((xFile) => File(xFile.path)).toList();
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      pickedImages.add(image);
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < pickedImages.length) {
      pickedImages.removeAt(index);
    }
  }

  var isLoading = false.obs;
  var responseData = Rxn<dynamic>();

  Future<void> submitReport(int alertType) async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getString('userId') ?? '';
    isLoading.value = true;

    try {
      await getCurrentLocation();
      bool hasInternet = await checkInternetConnection();

      if (hasInternet) {
        
        final alertModel = AlertModel(
          doctorId: savedUserId,
          alertDescriptionByDoctor: description.text,
          patientName: patientName.text,
          alertType: alertType,
          latitude: selectedLat.value,
          longitude: selectedLng.value,
          latitudeGps: currentLatGps.value,
          longitudeGps: currentLngGps.value,
          isOflineMode: false,
          localCreateTime: DateTime.now().toIso8601String(),
        );

        final response = await repository.submitAlert(
          alertModel,
          files: pickedImages,
        );

        responseData.value = response;

        Get.snackbar(
          'success'.tr, 
          'report_submitted_success'.tr, 
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 8,
        );

        clearForm();

        
        if (offlineReportsCount.value > 0) {
          syncOfflineReports();
        }
      } else {
    
        await saveOfflineReport(
          doctorId: savedUserId,
          patientName: patientName.text,
          alertDescription: description.text,
          alertType: alertType,
          latitude: selectedLat.value,
          longitude: selectedLng.value,
          latitudeGps: currentLatGps.value,
          longitudeGps: currentLngGps.value,
          localCreateTime: DateTime.now().toIso8601String(),
          images: pickedImages,

        );

        Get.snackbar(
          'offline_mode'.tr, 
          'offline_saved_message'.tr, 
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 8,
          duration: const Duration(seconds: 4),
        );

        clearForm();
      }
    } catch (e) {
      responseData.value = null;

      Get.snackbar(
        'error'.tr,
        'submit_failed'.tr, 
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    description.clear();
    patientName.clear();
    pickedImages.clear();
    selectedLat.value = 0.0;
    selectedLng.value = 0.0;
  }

  Future<bool> checkInternetConnection() async {
    try {
      final List<ConnectivityResult> connectivityResult = await Connectivity()
          .checkConnectivity();

      return !connectivityResult.contains(ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'location_service'.tr, 
          'location_disabled'.tr, 
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'location_permission'.tr, 
            'location_permanently_denied'.tr,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'location_permission'.tr, 
          'location_permanently_denied'.tr, 
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLatGps.value = position.latitude;
      currentLngGps.value = position.longitude;
    } catch (e) {
      Get.snackbar(
        'location_error'.tr, 
        'location_failed'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> checkOfflineReports() async {
    try {
      int count = await _dbHelper.getOfflineReportsCount();
      offlineReportsCount.value = count;
    } catch (e) {
     
    }
  }

  Future<void> saveOfflineReport({
    required String doctorId,
    required String patientName,
    required String alertDescription,
    required int alertType,
    required double latitude,
    required double longitude,
    required double latitudeGps,
    required double longitudeGps,
    required String localCreateTime,
    List<XFile>? images,
  }) async {
    try {
      List<File>? fileImages;
      if (images != null && images.isNotEmpty) {
        fileImages = convertXFilesToFiles(images);
      }

      await _dbHelper.saveOfflineReport(
        doctorId: doctorId,
        patientName: patientName,
        alertDescription: alertDescription,
        alertType: alertType,
        latitude: latitude,
        longitude: longitude,
        latitudeGps: latitudeGps,
        longitudeGps: longitudeGps,
        localCreateTime: localCreateTime,
        images: fileImages,
      );

      await checkOfflineReports();
    } catch (e) {
      throw e;
    }
  }

  Future<void> syncOfflineReports() async {
    try {
      bool hasInternet = await checkInternetConnection();
      if (!hasInternet) {
        print('no_internet_sync'.tr); 
        return;
      }

      List<Map<String, dynamic>> unsyncedReports = await _dbHelper
          .getUnsyncedReports();

      if (unsyncedReports.isEmpty) {
        print('no_offline_reports'.tr); 
        return;
      }

      int successCount = 0;

      for (var reportData in unsyncedReports) {
        try {
          List<XFile> xFileImages = [];
          if (reportData['images'] != null && reportData['images'].isNotEmpty) {
            List<String> imagePaths = List<String>.from(
              jsonDecode(reportData['images']),
            );
            xFileImages = imagePaths.map((path) => XFile(path)).toList();
          }

          final alertModel = AlertModel(
            doctorId: reportData['doctor_id'],
            alertDescriptionByDoctor: reportData['alert_description'],
            patientName: reportData['patient_name'],
            alertType: reportData['alert_type'],
            latitude: reportData['latitude'],
            longitude: reportData['longitude'],
            latitudeGps: reportData['latitude_gps'],
            longitudeGps: reportData['longitude_gps'],
            isOflineMode: true,
            localCreateTime: reportData['local_create_time'],
          );

          final response = await repository.submitAlert(
            alertModel,
            files: xFileImages,
          );

          if (response != null) {
            await _dbHelper.markAsSynced(reportData['id']);
            successCount++;
          }
        } catch (e) {
          continue;
        }
      }

      if (successCount > 0) {
        Get.snackbar(
          'sync_complete'.tr, 
          "$successCount ${'offline_synced'.tr}", 
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 8,
        );

        await checkOfflineReports();
      }
    } catch (e) {
      print("${'error_during_sync'.tr} $e"); 
      Get.snackbar(
        'sync_error'.tr, 
        'sync_failed'.tr, 
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}