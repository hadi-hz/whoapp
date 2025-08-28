import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/home/data/model/assign_role_model.dart';
import 'package:test3/features/home/data/model/assign_role_request_model.dart';


abstract class AssignRoleRemoteDataSource {
  Future<AssignRoleModel> assignRole(AssignRoleRequest request);
}

class AssignRoleRemoteDataSourceImpl implements AssignRoleRemoteDataSource {
 final Dio _dio = DioBase().dio;

  AssignRoleRemoteDataSourceImpl() ;

  @override
  Future<AssignRoleModel> assignRole(AssignRoleRequest request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.assignRole,
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': '*/*',
          },
        ),
      );

      if (response.statusCode == 200) {
        return AssignRoleModel.fromJson(response.data);
      } else {
        throw Exception('Failed to assign role: ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error assigning role: $e');
    }
  }
}