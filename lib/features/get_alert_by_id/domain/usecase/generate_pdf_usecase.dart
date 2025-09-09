
import 'package:test3/features/get_alert_by_id/domain/entities/generate_pdf_entity.dart';
import 'package:test3/features/get_alert_by_id/domain/repositories/generate_pdf_repository.dart';

class GeneratePdfReportUseCase {
  final ReportRepository _repository;

  GeneratePdfReportUseCase(this._repository);

  Future<ReportResponse> execute(String alertId) {
    if (alertId.isEmpty) {
      throw Exception('Alert ID is required');
    }
    return _repository.generatePdfReport(alertId);
  }
}