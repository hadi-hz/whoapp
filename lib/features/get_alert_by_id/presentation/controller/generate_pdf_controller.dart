import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/generate_pdf_entity.dart';
import 'package:test3/features/get_alert_by_id/domain/usecase/generate_pdf_usecase.dart';

class ReportController extends GetxController {
  final GeneratePdfReportUseCase _useCase;

  ReportController(this._useCase);

  final _isLoading = false.obs;
  final _message = ''.obs;
  final _isSuccess = false.obs;

  bool get isLoading => _isLoading.value;
  String get message => _message.value;
  bool get isSuccess => _isSuccess.value;

  Future<void> generatePdfReport(String alertId) async {
  print("generatePdfReport called with: $alertId"); // Debug
  
  if (alertId.isEmpty) {
    _message.value = 'alert_id_required'.tr;
    _isSuccess.value = false;
    return;
  }

  _isLoading.value = true;
  _message.value = '';
  print("Loading started"); // Debug

  try {
    print("Calling useCase.execute"); // Debug
    final response = await _useCase.execute(alertId);
    print("Response received: ${response.data.length} bytes"); // Debug
    
    await _savePdfFile(response);
    _message.value = 'pdf_generated_successfully'.tr;
    _isSuccess.value = true;
  } catch (e) {
    print("Error in generatePdfReport: $e"); // Debug
    _message.value = e.toString().contains('Rate limit') 
        ? 'rate_limit_exceeded'.tr 
        : 'pdf_generation_failed'.tr;
    _isSuccess.value = false;
  }

  _isLoading.value = false;
  print("Loading finished"); // Debug
}

Future<void> _savePdfFile(ReportResponse response) async {
  try {
  
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        final permission = await Permission.storage.request();
        if (!permission.isGranted) {
          throw Exception('Storage permission denied');
        }
      }
    }

    Directory? directory;
    if (Platform.isAndroid) {
  
      directory = await getExternalStorageDirectory();
      if (directory != null) {
        directory = Directory('${directory.path}/Download');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory == null) throw Exception('Could not access storage');

    final file = File('${directory.path}/${response.filename}');
    await file.writeAsBytes(response.data);
    
    print("PDF saved to: ${file.path}"); // Debug
    await OpenFile.open(file.path);
  } catch (e) {
    print("Save error: $e"); // Debug
    throw Exception('Failed to save PDF: $e');
  }
}
  void clearMessage() {
    _message.value = '';
    _isSuccess.value = false;
  }
}