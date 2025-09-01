import 'package:test3/features/home/domain/entities/team_detail_entity.dart';
import 'package:test3/features/home/domain/entities/team_member_entity.dart';

class TeamByIdResponseEntity {
  final TeamDetailEntity team;
  final List<TeamMemberEntity> members;

  TeamByIdResponseEntity({
    required this.team,
    required this.members,
  });
}