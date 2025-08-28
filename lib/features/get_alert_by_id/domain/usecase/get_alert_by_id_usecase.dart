
import 'package:dartz/dartz.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/get_alert-by_id.dart';
import 'package:test3/features/get_alert_by_id/domain/repositories/get_alert_by_id_repository.dart';


class GetAlertDetailUseCase {
  final AlertDetailRepository repository;

  GetAlertDetailUseCase(this.repository);

  Future<Either<String, AlertDetailEntity>> call(String alertId , String currentUserId) async {
    return await repository.getAlertById(alertId , currentUserId );
  }
}