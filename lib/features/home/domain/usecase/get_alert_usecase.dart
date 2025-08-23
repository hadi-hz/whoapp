import 'package:dartz/dartz.dart';
import 'package:test3/features/home/domain/entities/get_alert_entity.dart';
import 'package:test3/features/home/domain/repositories/get_alert_repository.dart';


class GetAllAlerts {
  final AlertRepository repository;

  GetAllAlerts(this.repository);

  Future<Either<String, List<Alert>>> call({
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
  }) {
    return repository.getAllAlerts(
      userId: userId,
      status: status,
      type: type,
      registerDateFrom: registerDateFrom,
      registerDateTo: registerDateTo,
      sortBy: sortBy,
      sortDescending: sortDescending,
      teamId: teamId,
      page: page,
      pageSize: pageSize,
    );
  }
}
