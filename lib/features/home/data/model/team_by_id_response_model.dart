import 'package:test3/features/home/data/model/team_detail_model.dart';

import '../../domain/entities/team_by_id_response_entity.dart';
import 'team_member_model.dart';

class TeamByIdResponseModel extends TeamByIdResponseEntity {
  TeamByIdResponseModel({
    required super.team,
    required super.members,
  });

  factory TeamByIdResponseModel.fromJson(Map<String, dynamic> json) {
    return TeamByIdResponseModel(
      team: TeamDetailModel.fromJson(json['teams'] ?? {}),
      members: (json['listMembers'] as List<dynamic>?)
          ?.map((member) => TeamMemberModel.fromJson(member))
          .toList() ?? [],
    );
  }
}
