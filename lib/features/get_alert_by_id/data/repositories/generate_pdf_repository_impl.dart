

import 'package:test3/features/get_alert_by_id/data/datasource/generate_pdf_datasource.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/generate_pdf_entity.dart';
import 'package:test3/features/get_alert_by_id/domain/repositories/generate_pdf_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource _dataSource;

  ReportRepositoryImpl(this._dataSource);

  @override
  Future<ReportResponse> generatePdfReport(String alertId) => 
      _dataSource.generatePdfReport(alertId);
}