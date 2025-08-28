import 'package:test3/features/home/domain/entities/get_alert_entity.dart';

class AlertModel extends AlertEntity {
  AlertModel({
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
    required super.trackId,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'],
      alertDescriptionByDoctor: json['alertDescriptionByDoctor'] ?? '',
      alertStatus: json['alertStatus'] ?? 0,
      alertType: json['alertType'] ?? 0,
      serverCreateTime: DateTime.parse(json['serverCreateTime']),
      doctorName: json['doctorName'] ?? '',
      doctorId: json['doctorId'] ?? '',
      teamName: json['teamName'],
      teamId: json['teamId'],
      isDoctor: json['isDoctor'] ?? false,
      isTeamMember: json['isTeamMember'] ?? false,
      trackId: json['trackId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alertDescriptionByDoctor': alertDescriptionByDoctor,
      'alertStatus': alertStatus,
      'alertType': alertType,
      'serverCreateTime': serverCreateTime.toIso8601String(),
      'doctorName': doctorName,
      'doctorId': doctorId,
      'teamName': teamName,
      'teamId': teamId,
      'isDoctor': isDoctor,
      'isTeamMember': isTeamMember,
      'trackId': trackId,
    };
  }
}
