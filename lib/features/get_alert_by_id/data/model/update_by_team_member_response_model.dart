import 'package:test3/features/get_alert_by_id/domain/entities/update_by_team_member_response.dart';

class UpdateAlertByTeamMemberResponseModel {
  final String message;
  final String id;
  final String updatedDescription;

  UpdateAlertByTeamMemberResponseModel({
    required this.message,
    required this.id,
    required this.updatedDescription,
  });

  factory UpdateAlertByTeamMemberResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateAlertByTeamMemberResponseModel(
      message: json['message'] ?? '',
      id: json['id'] ?? '',
      updatedDescription: json['updatedDescription'] ?? '',
    );
  }

  UpdateAlertByTeamMemberResponse toEntity() {
    return UpdateAlertByTeamMemberResponse(
      message: message,
      id: id,
      updatedDescription: updatedDescription,
    );
  }
}