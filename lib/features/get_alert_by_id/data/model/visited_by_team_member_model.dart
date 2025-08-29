import 'package:test3/features/get_alert_by_id/domain/entities/visited_by_team_member.dart';

class VisitedByTeamMemberModel {
  final String alertId;
  final String userId;

  VisitedByTeamMemberModel({required this.alertId, required this.userId});

  Map<String, dynamic> toJson() {
    return {'alertId': alertId, 'userId': userId};
  }

  factory VisitedByTeamMemberModel.fromRequest(
    VisitedByTeamMemberRequest request,
  ) {
    return VisitedByTeamMemberModel(
      alertId: request.alertId,
      userId: request.userId,
    );
  }
}

class VisitedByTeamMemberResponseModel {
  final String message;
  final String id;

  VisitedByTeamMemberResponseModel({required this.message, required this.id});

  factory VisitedByTeamMemberResponseModel.fromJson(Map<String, dynamic> json) {
    return VisitedByTeamMemberResponseModel(
      message: json['message'] ?? '',
      id: json['id'] ?? '',
    );
  }

  VisitedByTeamMemberResponse toEntity() {
    return VisitedByTeamMemberResponse(message: message, id: id);
  }
}
