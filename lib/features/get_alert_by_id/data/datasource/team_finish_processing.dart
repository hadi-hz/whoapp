import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/features/get_alert_by_id/data/model/team_finish_processing_model.dart';

abstract class TeamFinishProcessingRemoteDataSource {
  Future<TeamFinishProcessingModel> teamFinishProcessing({
    required String alertId,
    required String userId,
    required String description,
    List<XFile>? files,
  });
}

class TeamFinishProcessingRemoteDataSourceImpl
    implements TeamFinishProcessingRemoteDataSource {
  final Dio dio;

  TeamFinishProcessingRemoteDataSourceImpl(this.dio);

  @override
  Future<TeamFinishProcessingModel> teamFinishProcessing({
    required String alertId,
    required String userId,
    required String description,
    List<XFile>? files,
  }) async {
    try {
      // تشکیل FormData
      Map<String, dynamic> formMap = {
        'alertId': alertId,
        'userId': userId,
        'description': description,
      };

      // اضافه کردن فایل‌ها به FormData
      if (files != null && files.isNotEmpty) {
        List<MultipartFile> multipartFiles = [];
        for (var file in files) {
          multipartFiles.add(
            await MultipartFile.fromFile(file.path, filename: file.name),
          );
        }
        formMap['files'] = multipartFiles;
      }

      final formData = FormData.fromMap(formMap);

      final response = await dio.post(
        ApiEndpoints.teamFinishProcessing,
        data: formData,
      );

      return TeamFinishProcessingModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to finish processing: $e');
    }
  }
}