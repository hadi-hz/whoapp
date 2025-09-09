
import 'package:test3/features/get_alert_by_id/domain/entities/generate_pdf_entity.dart';

abstract class ReportRepository {
  Future<ReportResponse> generatePdfReport(String alertId);
}