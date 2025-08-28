
import 'package:test3/features/get_alert_by_id/domain/entities/teams.dart';

class TeamMemberModel extends TeamMemberEntity {
  TeamMemberModel({
    required String teamId,
    required String userId,
    dynamic user,
    required String id,
    required bool isDelete,
    required String createTime,
  }) : super(
          teamId: teamId,
          userId: userId,
          user: user,
          id: id,
          isDelete: isDelete,
          createTime: createTime,
        );

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      teamId: json['teamId'] ?? '',
      userId: json['userId'] ?? '',
      user: json['user'],
      id: json['id'] ?? '',
      isDelete: json['isDelete'] ?? false,
      createTime: json['createTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teamId': teamId,
      'userId': userId,
      'user': user,
      'id': id,
      'isDelete': isDelete,
      'createTime': createTime,
    };
  }
}