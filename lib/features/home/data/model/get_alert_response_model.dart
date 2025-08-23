import 'package:test3/features/home/domain/entities/get_alert_entity.dart';


class AlertModel extends Alert {
  const AlertModel({
    required super.id,
    required super.alertDescriptionByDoctor,
    required super.alertStatus,
    required super.alertType,
    required super.serverCreateTime,
    required super.doctorName,
    required super.doctorId,
    super.teamName,
    super.teamId,
    required super.isDoctor,
    required super.isTeamMember,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json["id"],
      alertDescriptionByDoctor: json["alertDescriptionByDoctor"],
      alertStatus: json["alertStatus"],
      alertType: json["alertType"],
      serverCreateTime: DateTime.parse(json["serverCreateTime"]),
      doctorName: json["doctorName"],
      doctorId: json["doctorId"],
      teamName: json["teamName"],
      teamId: json["teamId"],
      isDoctor: json["isDoctor"],
      isTeamMember: json["isTeamMember"],
    );
  }
}
