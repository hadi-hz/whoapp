import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/generate_pdf_entity.dart';

class ReportRemoteDataSource {
  final Dio _dio = DioBase().dio;
  Future<ReportResponse> generatePdfReport(String alertId) async {
    try {
      final response = await _dio.get(
       'https://gorgeous-repeatedly-haddock.ngrok-free.app/api/alert/generate-report',
        queryParameters: {'alertId': alertId, 'format': 'pdf'},
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'accept': '*/*'},
        ),
      );

      return ReportResponse(
        data: response.data,
        filename: 'report_$alertId.pdf',
        contentType: 'application/pdf',
      );
    } catch (e) {
      throw Exception('Failed to generate PDF report: ${e}');
    }
  }
}
