import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/auth/data/model/approved_request.dart';
import 'package:test3/features/auth/data/model/auth_by_google.dart';
import 'package:test3/features/auth/data/model/enum_model.dart';
import 'package:test3/features/auth/data/model/login_google_response_model.dart';
import 'package:test3/features/auth/data/model/login_request.dart';
import 'package:test3/features/auth/data/model/register_google_request_model.dart';
import 'package:test3/features/auth/data/model/register_google_response_model.dart';
import 'package:test3/features/auth/data/model/register_request.dart';
import 'package:test3/features/auth/domain/entities/login_google.dart';
import 'package:test3/features/auth/domain/entities/register_google.dart';

abstract class AuthRemoteDataSource {
  Future<dynamic> register(RegisterRequest request);
  Future<dynamic> login(LoginRequest request);
  Future<dynamic> checkUserIsApproved(ApprovedRequest request);
  Future<LoginGoogleEntity> loginWithGoogle(Map<String, dynamic> body);
  Future<EnumsResponseModel> getAllEnums();
  Future<RegisterGoogleEntity> registerWithGoogle(
    RegisterGoogleRequest request,
  );
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
  Future<LoginGoogleEntity> loginWithGoogle(Map<String, dynamic> body) async {
    final response = await _dio.post(ApiEndpoints.loginWithGoogle, data: body);
    return LoginGoogleResponseModel.fromJson(response.data).toEntity();
  }

  @override
  Future<EnumsResponseModel> getAllEnums() async {
    final response = await _dio.post(ApiEndpoints.enums);
    return EnumsResponseModel.fromJson(response.data);
  }

  Future<RegisterGoogleEntity> registerWithGoogle(
    RegisterGoogleRequest request,
  ) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.registerWithGoogle,
        data: request.toJson(),
      );

      final responseModel = RegisterGoogleResponse.fromJson(response.data);
      return responseModel.toEntity();
    } catch (e) {
      throw Exception('Failed to register with Google: $e');
    }
  }
}
