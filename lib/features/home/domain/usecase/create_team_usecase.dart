import 'package:test3/features/home/domain/entities/create_team.dart';
import 'package:test3/features/home/domain/entities/team_entity.dart';
import 'package:test3/features/home/domain/repositories/create_team_repository.dart';

class CreateTeamUseCase {
  final CreateTeamRepository repository;

  CreateTeamUseCase(this.repository);

  Future<TeamEntity> call(CreateTeamRequest request) async {
    return await repository.createTeam(request);
  }
}
