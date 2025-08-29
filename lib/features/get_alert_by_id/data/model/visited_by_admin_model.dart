import 'package:test3/features/get_alert_by_id/domain/entities/visited_by_admin.dart';

class VisitedByAdminModel {
  final String alertId;
  final String userId;

  VisitedByAdminModel({
    required this.alertId,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'alertId': alertId,
      'userId': userId,
    };
  }

  factory VisitedByAdminModel.fromRequest(VisitedByAdminRequest request) {
    return VisitedByAdminModel(
      alertId: request.alertId,
      userId: request.userId,
    );
  }
}

class VisitedByAdminResponseModel {
  final String message;
  final String id;

  VisitedByAdminResponseModel({
    required this.message,
    required this.id,
  });

  factory VisitedByAdminResponseModel.fromJson(Map<String, dynamic> json) {
    return VisitedByAdminResponseModel(
      message: json['message'] ?? '',
      id: json['id'] ?? '',
    );
  }

  VisitedByAdminResponse toEntity() {
    return VisitedByAdminResponse(
      message: message,
      id: id,
    );
  }
}