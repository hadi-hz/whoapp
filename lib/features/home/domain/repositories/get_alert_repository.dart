import 'package:dartz/dartz.dart';
import 'package:test3/features/home/domain/entities/get_alert_entity.dart';
import 'package:test3/features/home/domain/entities/get_filter_alert.dart';

abstract class AlertListRepository {
  Future<Either<String, List<AlertEntity>>> getAllAlerts(AlertFilterEntity filter);
}