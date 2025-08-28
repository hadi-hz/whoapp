import 'package:test3/features/home/data/datasource/get_teams_by_member_id.dart';
import 'package:test3/features/home/domain/entities/team_entity.dart';
import 'package:test3/features/home/domain/repositories/get_teams_by_member_id.dart';

class GetTeamsByUserRepositoryImpl implements GetTeamsByUserRepository {
  final GetTeamsByUserRemoteDataSource remoteDataSource;

  GetTeamsByUserRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<TeamEntity>> getTeamsByUserId(String userId) async {
    final teamModels = await remoteDataSource.getTeamsByUserId(userId);
    return teamModels.map((model) => model.toEntity()).toList();
  }
}