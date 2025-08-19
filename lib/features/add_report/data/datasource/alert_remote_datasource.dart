import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test3/features/add_report/data/model/alert_model.dart';

abstract class AlertRemoteDataSource {
  Future<dynamic> submitAlert(AlertModel request, {List<XFile>? files});
}

class AlertRemoteDataSourceImpl implements AlertRemoteDataSource {
  final Dio _dio = DioBase().dio;

  @override
  Future<dynamic> submitAlert(AlertModel request, {List<XFile>? files}) async {
    List<MultipartFile> multipartFiles = [];

    if (files != null) {
      for (var file in files) {
        multipartFiles.add(
          await MultipartFile.fromFile(file.path, filename: file.name),
        );
      }
    }

    FormData formData = FormData.fromMap({
      ...request.toJson(),
      "files": multipartFiles,
    });

    return await _dio.post(ApiEndpoints.alertCreate, data: formData);
  }
}
