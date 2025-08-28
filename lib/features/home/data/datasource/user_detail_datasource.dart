import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/home/data/model/user_detail_model.dart';
import 'package:test3/features/home/data/model/user_detail_request_model.dart';

abstract class UserDetailRemoteDataSource {
  Future<UserDetailModel> getUserInfo(UserDetailRequest request);
}

class UserDetailRemoteDataSourceImpl implements UserDetailRemoteDataSource {
   final Dio _dio = DioBase().dio;


  UserDetailRemoteDataSourceImpl() ;

  @override
  Future<UserDetailModel> getUserInfo(UserDetailRequest request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getUserInfo,
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': '*/*',
          },
        ),
      );

      if (response.statusCode == 200) {
        return UserDetailModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get user info: ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error getting user info: $e');
    }
  }
}
