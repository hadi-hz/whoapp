import 'package:dartz/dartz.dart';
import 'package:test3/features/home/data/datasource/get_alert_datasource.dart';
import 'package:test3/features/home/data/model/get_filter_alert_model.dart';
import 'package:test3/features/home/domain/entities/get_alert_entity.dart';
import 'package:test3/features/home/domain/entities/get_filter_alert.dart';
import 'package:test3/features/home/domain/repositories/get_alert_repository.dart';


class AlertListRepositoryImpl implements AlertListRepository {
  final GetAlertRemoteDataSource remoteDataSource;

  AlertListRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<AlertEntity>>> getAllAlerts(AlertFilterEntity filter) async {
    try {
      final alertFilter = AlertFilterModel(
        search: filter.search,
        userId: filter.userId,
        status: filter.status,
        type: filter.type,
        registerDateFrom: filter.registerDateFrom,
        registerDateTo: filter.registerDateTo,
        sortBy: filter.sortBy,
        sortDescending: filter.sortDescending,
        teamId: filter.teamId,
        page: filter.page,
        pageSize: filter.pageSize,
      );

      final result = await remoteDataSource.getAllAlerts(alertFilter);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}