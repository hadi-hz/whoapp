import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/home/data/model/team_model.dart';

abstract class GetTeamsByUserRemoteDataSource {
  Future<List<TeamModel>> getTeamsByUserId(String userId);
}

class GetTeamsByUserRemoteDataSourceImpl implements GetTeamsByUserRemoteDataSource {
 final Dio _dio = DioBase().dio;
 

  GetTeamsByUserRemoteDataSourceImpl();

  @override
  Future<List<TeamModel>> getTeamsByUserId(String userId) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.teamsByMemberId,
        queryParameters: {'userId': userId},
      );

      final List<dynamic> data = response.data;
      return data.map((json) => TeamModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get teams by user: $e');
    }
  }
}
