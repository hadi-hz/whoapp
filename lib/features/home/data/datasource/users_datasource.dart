import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/home/data/model/users_filter.dart';
import 'package:test3/features/home/data/model/users_model.dart';


abstract class UsersRemoteDataSource {
  Future<List<UserModel>> getAllUsers(UsersFilterModel filter);
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final Dio _dio = DioBase().dio;

  UsersRemoteDataSourceImpl() ;  
  @override
  Future<List<UserModel>> getAllUsers(UsersFilterModel filter) async {
    try {
      final response = await _dio.post(
      ApiEndpoints.userGetAll,
        queryParameters: filter.toQueryParams(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': '*/*',
          },
        ),
        data: '', 
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get users: ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error getting users: $e');
    }
  }
}