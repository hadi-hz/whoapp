import 'package:dartz/dartz.dart';
import 'package:test3/features/home/data/datasource/admin_close_alert_datasource.dart';
import 'package:test3/features/home/data/model/admin_close_alert_request_model.dart';
import 'package:test3/features/home/domain/entities/admin_close_alert.dart';
import 'package:test3/features/home/domain/repositories/admin_close_alert.dart';
import '../../domain/entities/admin_close_alert_response.dart';

class AdminCloseAlertRepositoryImpl implements AdminCloseAlertRepository {
  final AdminCloseAlertRemoteDataSource remoteDataSource;

  AdminCloseAlertRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, AdminCloseAlertResponse>> closeAlert(
    AdminCloseAlertRequest request,
  ) async {
    try {
      final requestModel = AdminCloseAlertRequestModel(
        alertId: request.alertId,
        userId: request.userId,
      );
      final result = await remoteDataSource.closeAlert(requestModel);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
