import 'package:test3/features/home/domain/entities/admin_close_alert_response.dart';


class AdminCloseAlertRequestModel extends AdminCloseAlertRequest {
  AdminCloseAlertRequestModel({
    required super.alertId,
    required super.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'alertId': alertId,
      'userId': userId,
    };
  }
}