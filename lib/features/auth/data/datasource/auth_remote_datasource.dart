import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/auth/data/model/approved_request.dart';
import 'package:test3/features/auth/data/model/auth_by_google.dart';
import 'package:test3/features/auth/data/model/enum_model.dart';
import 'package:test3/features/auth/data/model/login_request.dart';
import 'package:test3/features/auth/data/model/register_request.dart';

abstract class AuthRemoteDataSource {
  Future<dynamic> register(RegisterRequest request);
  Future<dynamic> login(LoginRequest request);
  Future<dynamic> checkUserIsApproved(ApprovedRequest request);
  Future<AuthModel> loginWithGoogle(Map<String, dynamic> body);
  Future<EnumsResponseModel> getAllEnums();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio = DioBase().dio;

  Future<dynamic> register(RegisterRequest request) async {
    return await _dio.post(ApiEndpoints.register, data: request.toJson());
  }

  Future<dynamic> login(LoginRequest request) async {
    return await _dio.post(ApiEndpoints.login, data: request.toJson());
  }

  Future<dynamic> checkUserIsApproved(ApprovedRequest request) async {
    return await _dio.post(
      ApiEndpoints.checkUserIsApproved,
      data: request.toJson(),
    );
  }

  @override
  Future<AuthModel> loginWithGoogle(Map<String, dynamic> body) async {
    final response = await _dio.post(ApiEndpoints.loginWithGoogle, data: body);
    return AuthModel.fromJson(response.data);
  }



  
   @override
  Future<EnumsResponseModel> getAllEnums() async {
    final response = await _dio.post(ApiEndpoints.enums);
    return EnumsResponseModel.fromJson(response.data);
  }
}
