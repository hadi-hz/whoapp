

import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/get_alert_by_id/data/model/get_alert_by_id_model.dart';
import 'package:test3/features/get_alert_by_id/data/model/get_alert_by_id_request.dart';


abstract class AlertDetailRemoteDataSource {
  Future<AlertDetailModel> getAlertById(AlertDetailRequest request);
}

class AlertDetailRemoteDataSourceImpl implements AlertDetailRemoteDataSource {
 final Dio _dio = DioBase().dio;

  AlertDetailRemoteDataSourceImpl() ;

  

@override
Future<AlertDetailModel> getAlertById(AlertDetailRequest request) async {
  try {
   
    
    final response = await _dio.post(
      ApiEndpoints.geAlertById,
      data: request.toJson(),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        
        },
      ),
    );

    if (response.statusCode == 200) {
      return AlertDetailModel.fromJson(response.data);
    } else {
      throw Exception('Failed to get alert detail: ${response.statusMessage}');
    }
  } catch (e) {
    // Log the error
    print('Error getting alert detail: $e');
    
    // Re-throw with a user-friendly message
    if (e.toString().contains('SocketException')) {
      throw Exception('No internet connection');
    } else if (e.toString().contains('TimeoutException')) {
      throw Exception('Request timeout');
    } else {
      throw Exception('Failed to get alert detail');
    }
  }
}
}