import 'package:dartz/dartz.dart';
import 'package:test3/features/home/data/datasource/get_alert_datasource.dart';
import 'package:test3/features/home/domain/entities/get_alert_entity.dart';
import 'package:test3/features/home/domain/repositories/get_alert_repository.dart';


class GetAlertRepositoryImpl implements AlertRepository {
  final GetAlertRemoteDataSource remoteDataSource;

  GetAlertRepositoryImpl(this.remoteDataSource);

  @override
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
  }) async {
    try {
      final result = await remoteDataSource.getAllAlerts({
        "UserId": userId,
        if (status != null) "Status": status,
        if (type != null) "Type": type,
        if (registerDateFrom != null) "RegisterDateFrom": registerDateFrom,
        if (registerDateTo != null) "RegisterDateTo": registerDateTo,
        if (sortBy != null) "SortBy": sortBy,
        "SortDescending": sortDescending,
        if (teamId != null) "TeamId": teamId,
        "Page": page,
        "PageSize": pageSize,
      });
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
