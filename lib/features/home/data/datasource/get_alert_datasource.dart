import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/features/home/data/model/get_alert_response_model.dart';
import 'package:test3/features/home/data/model/get_filter_alert_model.dart';

abstract class GetAlertRemoteDataSource {
  Future<List<AlertModel>> getAllAlerts(AlertFilterModel filter);
}

class GetAlertRemoteDataSourceImpl implements GetAlertRemoteDataSource {
  final Dio dio;

  GetAlertRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<AlertModel>> getAllAlerts(AlertFilterModel filter) async {
    try {
      final response = await dio.post(
        ApiEndpoints.getAllAlert,
        queryParameters: filter.toQueryParams(),
        options: Options(
          headers: {
            'accept': '*/*',
            'Content-Type': 'application/json',
          },
        ),
      );

      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => AlertModel.fromJson(json)).toList();
      
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response!.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}