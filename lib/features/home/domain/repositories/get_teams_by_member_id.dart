import 'package:test3/features/home/domain/entities/team_entity.dart';

abstract class GetTeamsByUserRepository {
  Future<List<TeamEntity>> getTeamsByUserId(String userId);
}