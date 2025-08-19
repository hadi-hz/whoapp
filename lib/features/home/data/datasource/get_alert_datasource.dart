import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/home/data/model/get_alert_model.dart';
import 'package:test3/features/home/data/model/get_alert_response_model.dart';


abstract class GetAlertRemoteDataSource {
  Future<List<GetAlertResponseModel>> getAlerts(GetAlertRequestModel request);
}

class GetAlertRemoteDataSourceImpl implements GetAlertRemoteDataSource {
  final Dio _dio = DioBase().dio;

  @override
  Future<List<GetAlertResponseModel>> getAlerts(GetAlertRequestModel request) async {
    final response = await _dio.post(
      ApiEndpoints.getAllAlert,
      data: request.toJson(),
    );

    if (response.statusCode == 200) {
      final List data = response.data as List;
      return data.map((e) => GetAlertResponseModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load alerts');
    }
  }
}
