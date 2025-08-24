import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';

import 'package:test3/features/home/data/model/get_alert_response_model.dart';

abstract class GetAlertRemoteDataSource {
  Future<List<AlertModel>> getAllAlerts(Map<String, dynamic> params);
  
}

class GetAlertRemoteDataSourceImpl implements GetAlertRemoteDataSource {
  final Dio _dio = DioBase().dio;

  @override
  Future<List<AlertModel>> getAllAlerts(Map<String, dynamic> params) async {
    final response = await _dio.post(
      ApiEndpoints.getAllAlert,
      queryParameters: params,
      data: {},
    );

    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((e) => AlertModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load alerts");
    }
  }


}
