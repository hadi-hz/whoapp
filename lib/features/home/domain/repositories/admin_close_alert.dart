import 'package:dartz/dartz.dart';
import 'package:test3/features/home/domain/entities/admin_close_alert.dart';
import '../entities/admin_close_alert_response.dart';

abstract class AdminCloseAlertRepository {
  Future<Either<String, AdminCloseAlertResponse>> closeAlert(AdminCloseAlertRequest request);
}