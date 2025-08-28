import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/get_alert_by_id/data/model/assign_team_model.dart';
import 'package:test3/features/get_alert_by_id/data/model/assign_team_request_model.dart';

abstract class AssignTeamRemoteDataSource {
  Future<AssignTeamModel> assignTeamToAlert(AssignTeamRequest request);
}

class AssignTeamRemoteDataSourceImpl implements AssignTeamRemoteDataSource {
  final Dio _dio = DioBase().dio;

  AssignTeamRemoteDataSourceImpl();

  @override
  Future<AssignTeamModel> assignTeamToAlert(AssignTeamRequest request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.assignTeamToAlert,
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AssignTeamModel.fromJson(response.data);
      } else {
        throw Exception('Failed to assign team: ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(
          'Server error: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error assigning team: $e');
    }
  }
}
