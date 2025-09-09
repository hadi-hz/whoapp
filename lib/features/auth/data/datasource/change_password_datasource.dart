import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/auth/domain/entities/change_password_entity.dart';

class ChangePasswordRemoteDataSource {
  final Dio _dio = DioBase().dio;

  Future<ApiResponse> forgetPassword(String email) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.changePassword,
        data: {'email': email},
      );

      return ApiResponse.fromJson(response.data);
    } catch (e) {
      throw Exception(' $e');
    }
  }
}
