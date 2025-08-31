

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/features/get_alert_by_id/data/model/team_finish_processing_model.dart';

abstract class TeamFinishProcessingRemoteDataSource {
  Future<TeamFinishProcessingModel> teamFinishProcessing({
    required String alertId,
    required String userId,
    required String description,
    List<String>? files,
  });
}



class TeamFinishProcessingRemoteDataSourceImpl implements TeamFinishProcessingRemoteDataSource {
  final Dio dio;

  TeamFinishProcessingRemoteDataSourceImpl(this.dio);

  @override
  Future<TeamFinishProcessingModel> teamFinishProcessing({
    required String alertId,
    required String userId,
    required String description,
    List<String>? files,
  }) async {
    try {
      final formData = FormData.fromMap({
        'alertId': alertId,
        'userId': userId,
        'description': description,
        if (files != null) 'files': files,
      });

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