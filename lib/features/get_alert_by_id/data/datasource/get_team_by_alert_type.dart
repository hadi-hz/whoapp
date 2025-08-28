import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/get_alert_by_id/data/model/team_model.dart';

abstract class TeamRemoteDataSource {
  Future<List<TeamModel>> getTeamByAlertType(int alertType);
}

class TeamRemoteDataSourceImpl implements TeamRemoteDataSource {
  final Dio _dio = DioBase().dio;

  TeamRemoteDataSourceImpl();

  @override
  Future<List<TeamModel>> getTeamByAlertType(int alertType) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getallTeams,
        data: {'alertType': alertType},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        print('Response data type: ${response.data.runtimeType}');
        print('Response data: ${response.data}');

        List<dynamic> jsonList = response.data;
        return jsonList.map((json) => TeamModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get team: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in getTeamByAlertType: $e');
      throw Exception('Error getting team: $e');
    }
  }
}
