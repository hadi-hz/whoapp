import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/add_report/data/model/alert_model.dart';
import 'package:test3/features/add_report/domain/repositories/alert_repository.dart';

class AddReportController extends GetxController {
  final AlertRepository repository;

  AddReportController(this.repository);

  var selectedLat = 48.8566.obs;
  var selectedLng = 2.3522.obs;

  final TextEditingController description = TextEditingController();

  RxList<XFile> pickedImages = <XFile>[].obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      pickedImages.add(image);
    }
  }

  final services = [
    'health service 1',
    'health service 2',
    'health service 3',
    'health service 4',
  ];

  var selectedServiceIndex = (-1).obs;

  void changeService(String? value) {
    if (value != null) {
      final index = services.indexOf(value);
      if (index != -1) selectedServiceIndex.value = index;
    }
  }

  var isLoading = false.obs;
  var responseData = Rxn<dynamic>();

  Future<void> submitReport() async {
    print('helloo bitch');
  
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getString('userId') ?? '';
    isLoading.value = true;

    try {
      final alertModel = AlertModel(
        doctorId: savedUserId,
        alertDescriptionByDoctor: description.text,
        alertType: selectedServiceIndex.value,
        latitude: selectedLat.value,
        longitude: selectedLng.value,
        localCreateTime: DateTime.now().toIso8601String(),
      );

      final response = await repository.submitAlert(
        alertModel,
        files: pickedImages,
      );

      responseData.value = response;
      print("Report submitted: $response");
    } catch (e) {
      print("Error submitting report: $e");
      responseData.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
