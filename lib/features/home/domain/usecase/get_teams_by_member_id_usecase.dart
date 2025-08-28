import 'package:test3/features/home/domain/entities/team_entity.dart';
import 'package:test3/features/home/domain/repositories/get_teams_by_member_id.dart';

class GetTeamsByUserUseCase {
  final GetTeamsByUserRepository repository;

  GetTeamsByUserUseCase(this.repository);

  Future<List<TeamEntity>> call(String userId) async {
    return await repository.getTeamsByUserId(userId);
  }
}