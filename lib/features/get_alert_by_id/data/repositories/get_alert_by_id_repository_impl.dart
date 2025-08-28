// lib/features/alert_detail/data/repositories/alert_detail_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:test3/features/get_alert_by_id/data/datasource/get_alert_by_id_datasource.dart';
import 'package:test3/features/get_alert_by_id/data/model/get_alert_by_id_request.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/get_alert-by_id.dart';
import 'package:test3/features/get_alert_by_id/domain/repositories/get_alert_by_id_repository.dart';


class AlertDetailRepositoryImpl implements AlertDetailRepository {
  final AlertDetailRemoteDataSource remoteDataSource;

  AlertDetailRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, AlertDetailEntity>> getAlertById(String alertId ,currentUserId ) async {
    try {
      final request = AlertDetailRequest(alertId: alertId , currentUserId: currentUserId);
      final result = await remoteDataSource.getAlertById(request);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}