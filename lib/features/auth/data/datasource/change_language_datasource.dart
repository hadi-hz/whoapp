import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/features/auth/data/model/change_language_model.dart';
import 'package:test3/features/auth/data/model/change_language_response_model.dart';

abstract class ChangeLanguageRemoteDataSource {
  Future<ChangeLanguageResponseModel> changeLanguage(ChangeLanguageModel model);
}

class ChangeLanguageRemoteDataSourceImpl implements ChangeLanguageRemoteDataSource {
  final Dio dio;
  

  ChangeLanguageRemoteDataSourceImpl(this.dio);

  @override
  Future<ChangeLanguageResponseModel> changeLanguage(ChangeLanguageModel model) async {
    try {
      final response = await dio.post(
        ApiEndpoints.changeLanguage , 
        data: model.toJson(),
      );
      return ChangeLanguageResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to change language: $e');
    }
  }
}