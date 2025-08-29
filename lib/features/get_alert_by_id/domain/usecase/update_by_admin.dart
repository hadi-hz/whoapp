import 'package:test3/features/get_alert_by_id/domain/entities/update_by_admin.dart';
import 'package:test3/features/get_alert_by_id/domain/repositories/update_by_admin.dart';

class UpdateAlertByAdminUseCase {
  final UpdateAlertByAdminRepository repository;

  UpdateAlertByAdminUseCase(this.repository);

  Future<UpdateAlertByAdminResponse> call(UpdateAlertByAdminRequest request) async {
    return await repository.updateAlertByAdmin(request);
  }
}