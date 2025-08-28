import 'package:test3/features/home/domain/entities/add_members.dart';
import 'package:test3/features/home/domain/entities/create_team.dart';
import 'package:test3/features/home/domain/entities/team_entity.dart';

abstract class CreateTeamRepository {
  Future<TeamEntity> createTeam(CreateTeamRequest request);
  Future<void> addMembers(AddMembersRequest request);
}