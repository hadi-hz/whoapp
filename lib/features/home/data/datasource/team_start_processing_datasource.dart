import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/home/data/model/team_start_processing_model.dart';

abstract class TeamStartProcessingRemoteDataSource {
  Future<TeamStartProcessingResponseModel> teamStartProcessing(TeamStartProcessingModel model);
}

class TeamStartProcessingRemoteDataSourceImpl implements TeamStartProcessingRemoteDataSource {
 final Dio dio;
  

  TeamStartProcessingRemoteDataSourceImpl(this.dio);

  @override
  Future<TeamStartProcessingResponseModel> teamStartProcessing(TeamStartProcessingModel model) async {
    try {
      final response = await dio.post(
        ApiEndpoints.teamStartProcessing,
        data: model.toJson(),
      );
      return TeamStartProcessingResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to start team processing: $e');
    }
  }
}