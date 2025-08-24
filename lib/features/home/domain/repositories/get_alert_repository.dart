import 'package:dartz/dartz.dart';
import 'package:test3/features/home/domain/entities/get_alert_entity.dart';

abstract class AlertRepository {
  Future<Either<String, List<Alert>>> getAllAlerts({
    required String userId,
    int? status,
    int? type,
    String? registerDateFrom,
    String? registerDateTo,
    String? sortBy,
    required bool sortDescending,
    String? teamId,
    required int page,
    required int pageSize,
  });

 
}
