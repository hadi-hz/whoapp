import 'package:test3/features/home/domain/entities/team_entity.dart';
import 'package:test3/features/home/domain/repositories/team_repository.dart';

class GetTeamByIdUseCase {
  final TeamsRepository repository;

  GetTeamByIdUseCase(this.repository);

  Future<TeamEntity> call(String id) async {
    return await repository.getTeamById(id);
  }
}