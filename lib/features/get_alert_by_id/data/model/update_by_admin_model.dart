import 'package:test3/features/get_alert_by_id/domain/entities/update_by_admin.dart';

class UpdateAlertByAdminModel {
  final String alertId;
  final String description;
  final String userId;

  UpdateAlertByAdminModel({
    required this.alertId,
    required this.description,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'alertId': alertId,
      'description': description,
      'userId': userId,
    };
  }

  factory UpdateAlertByAdminModel.fromRequest(UpdateAlertByAdminRequest request) {
    return UpdateAlertByAdminModel(
      alertId: request.alertId,
      description: request.description,
      userId: request.userId,
    );
  }
}
