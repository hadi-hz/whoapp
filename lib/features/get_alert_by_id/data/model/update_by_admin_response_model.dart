import 'package:test3/features/get_alert_by_id/domain/entities/update_by_admin.dart';

class UpdateAlertByAdminResponseModel {
  final String message;
  final String id;
  final String updatedDescription;

  UpdateAlertByAdminResponseModel({
    required this.message,
    required this.id,
    required this.updatedDescription,
  });

  factory UpdateAlertByAdminResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateAlertByAdminResponseModel(
      message: json['message'] ?? '',
      id: json['id'] ?? '',
      updatedDescription: json['updatedDescription'] ?? '',
    );
  }

  UpdateAlertByAdminResponse toEntity() {
    return UpdateAlertByAdminResponse(
      message: message,
      id: id,
      updatedDescription: updatedDescription,
    );
  }
}
