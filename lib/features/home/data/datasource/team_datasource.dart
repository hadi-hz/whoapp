import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/home/data/model/team_filter_model.dart';
import 'package:test3/features/home/data/model/team_model.dart';

abstract class TeamsRemoteDataSource {
  Future<List<TeamModel>> getAllTeams(TeamsFilterModel filter);
}

class TeamsRemoteDataSourceImpl implements TeamsRemoteDataSource {
  final Dio _dio = DioBase().dio;

  TeamsRemoteDataSourceImpl();

  @override
  Future<List<TeamModel>> getAllTeams(TeamsFilterModel filter) async {
    try {
      final queryParams = filter.toQueryParams();
      print('Query params: $queryParams'); // اضافه کنید این خط
      final response = await _dio.post(
        ApiEndpoints.teamsGetAll,
        queryParameters: queryParams,
        options: Options(
          headers: {'Content-Type': 'application/json', 'accept': '*/*'},
        ),
        data: '',
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => TeamModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get teams: ${response.statusCode}');
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
      throw Exception('Error getting teams: $e');
    }
  }
}
