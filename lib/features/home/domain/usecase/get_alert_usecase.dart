import 'package:dartz/dartz.dart';
import 'package:test3/features/home/domain/entities/get_alert_entity.dart';
import 'package:test3/features/home/domain/entities/get_filter_alert.dart';
import 'package:test3/features/home/domain/repositories/get_alert_repository.dart';


class GetAlertsUseCase {
  final AlertListRepository repository;

  GetAlertsUseCase(this.repository);

  Future<Either<String, List<AlertEntity>>> call(AlertFilterEntity filter) async {
    return await repository.getAllAlerts(filter);
  }
}