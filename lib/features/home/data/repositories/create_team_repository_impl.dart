import 'package:test3/features/home/data/datasource/create_team_datasource.dart';
import 'package:test3/features/home/data/model/add_member_model.dart';
import 'package:test3/features/home/data/model/create_team_model.dart';
import 'package:test3/features/home/domain/entities/add_members.dart';
import 'package:test3/features/home/domain/entities/create_team.dart';
import 'package:test3/features/home/domain/entities/team_entity.dart';
import 'package:test3/features/home/domain/repositories/create_team_repository.dart';

class CreateTeamRepositoryImpl implements CreateTeamRepository {
  final CreateTeamRemoteDataSource remoteDataSource;

  CreateTeamRepositoryImpl(this.remoteDataSource);

  @override
  Future<TeamEntity> createTeam(CreateTeamRequest request) async {
    final model = CreateTeamModel.fromRequest(request);
    final teamModel = await remoteDataSource.createTeam(model);
    return teamModel.toEntity();
  }

  @override
  Future<void> addMembers(AddMembersRequest request) async {
    final model = AddMembersModel.fromRequest(request);
    await remoteDataSource.addMembers(model);
  }
}