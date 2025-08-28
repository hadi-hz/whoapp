import 'package:test3/features/get_alert_by_id/domain/entities/assign_team.dart';


class AssignTeamModel extends AssignTeamEntity {
  AssignTeamModel({
    required String message,
    required String id,
    required String name,
  }) : super(
          message: message,
          id: id,
          name: name,
        );

  factory AssignTeamModel.fromJson(Map<String, dynamic> json) {
    return AssignTeamModel(
      message: json['message'] ?? '',
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'id': id,
      'name': name,
    };
  }
}
