import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/features/home/data/model/admin_close_alert_request_model.dart';
import 'package:test3/features/home/data/model/admin_close_alert_response_model.dart';

abstract class AdminCloseAlertRemoteDataSource {
  Future<AdminCloseAlertResponseModel> closeAlert(
    AdminCloseAlertRequestModel request,
  );
}

class AdminCloseAlertRemoteDataSourceImpl
    implements AdminCloseAlertRemoteDataSource {
  final Dio dio;

  AdminCloseAlertRemoteDataSourceImpl({required this.dio});

  @override
  Future<AdminCloseAlertResponseModel> closeAlert(
    AdminCloseAlertRequestModel request,
  ) async {
    try {
      final response = await dio.post(
        ApiEndpoints.adminCloseAlert,
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json', 'accept': '*/*'},
        ),
      );

      return AdminCloseAlertResponseModel.fromJson(response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('Failed to close alert: ${e.response!.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }
}
