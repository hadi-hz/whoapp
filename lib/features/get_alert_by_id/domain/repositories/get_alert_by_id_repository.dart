
import 'package:dartz/dartz.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/get_alert-by_id.dart';

abstract class AlertDetailRepository {
  Future<Either<String, AlertDetailEntity>> getAlertById(String alertId);
}