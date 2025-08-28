import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/home/data/model/team_model.dart';

abstract class TeamRemoteDataSourceTeamId {
  Future<TeamModel> getTeamById(String id);
}

class TeamRemoteDataSourceImplTeamId implements TeamRemoteDataSourceTeamId {
  final Dio _dio = DioBase().dio;
  

  TeamRemoteDataSourceImplTeamId();

  @override
  Future<TeamModel> getTeamById(String id) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.teamsGetbyId,
        queryParameters: {'id': id},
      );
      return TeamModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get team: $e');
    }
  }
}