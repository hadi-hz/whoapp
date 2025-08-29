import 'package:test3/features/get_alert_by_id/domain/entities/update_by_admin.dart';

abstract class UpdateAlertByAdminRepository {
  Future<UpdateAlertByAdminResponse> updateAlertByAdmin(UpdateAlertByAdminRequest request);
}