import '../../domain/entities/get_alert_entity.dart';

class GetAlertResponseModel {
  final String id;
  final String alertDescriptionByDoctor;
  final int alertStatus;
  final int alertType;
  final DateTime serverCreateTime;
  final bool isDoctor;
  final bool isTeamMember;

  GetAlertResponseModel({
    required this.id,
    required this.alertDescriptionByDoctor,
    required this.alertStatus,
    required this.alertType,
    required this.serverCreateTime,
    required this.isDoctor,
    required this.isTeamMember,
  });

  factory GetAlertResponseModel.fromJson(Map<String, dynamic> json) {
    return GetAlertResponseModel(
      id: json['id'],
      alertDescriptionByDoctor: json['alertDescriptionByDoctor'],
      alertStatus: json['alertStatus'],
      alertType: json['alertType'],
      serverCreateTime: DateTime.parse(json['serverCreateTime']),
      isDoctor: json['isDoctor'],
      isTeamMember: json['isTeamMember'],
    );
  }

  GetAlertEntity toEntity() {
    return GetAlertEntity(
      id: id,
      alertDescriptionByDoctor: alertDescriptionByDoctor,
      alertStatus: alertStatus,
      alertType: alertType,
      serverCreateTime: serverCreateTime,
      isDoctor: isDoctor,
      isTeamMember: isTeamMember,
    );
  }
}
