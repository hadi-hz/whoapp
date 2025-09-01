import 'package:dartz/dartz.dart';
import 'package:test3/features/home/domain/entities/admin_close_alert.dart';
import 'package:test3/features/home/domain/repositories/admin_close_alert.dart';
import '../entities/admin_close_alert_response.dart';

class CloseAlertUseCase {
  final AdminCloseAlertRepository repository;

  CloseAlertUseCase(this.repository);

  Future<Either<String, AdminCloseAlertResponse>> call(AdminCloseAlertRequest request) async {
    return await repository.closeAlert(request);
  }
}