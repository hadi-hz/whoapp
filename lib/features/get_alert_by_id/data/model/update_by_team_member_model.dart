import 'package:test3/features/get_alert_by_id/domain/entities/update_by_team_member.dart';

class UpdateAlertByTeamMemberModel {
  final String alertId;
  final String description;
  final String userId;

  UpdateAlertByTeamMemberModel({
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

  factory UpdateAlertByTeamMemberModel.fromRequest(UpdateAlertByTeamMemberRequest request) {
    return UpdateAlertByTeamMemberModel(
      alertId: request.alertId,
      description: request.description,
      userId: request.userId,
    );
  }
}
