

import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/features/home/data/model/team_by_id_response_model.dart';

abstract class GetTeamByIdRemoteDataSource {
  Future<TeamByIdResponseModel> getTeamById(String teamId);
}

class GetTeamByIdRemoteDataSourceImpl implements GetTeamByIdRemoteDataSource {
  final Dio dio;

  GetTeamByIdRemoteDataSourceImpl({required this.dio});

  @override
  Future<TeamByIdResponseModel> getTeamById(String teamId) async {
    try {
      final response = await dio.post(
        ApiEndpoints.teamsGetbyId,
        queryParameters: {'id': teamId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': '*/*',
          },
        ),
      );

      return TeamByIdResponseModel.fromJson(response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('Failed to get team details: ${e.response!.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }
}