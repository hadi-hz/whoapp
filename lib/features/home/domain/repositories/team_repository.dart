import 'package:dartz/dartz.dart';
import 'package:test3/features/home/domain/entities/team_filter_entity.dart';
import '../entities/team_entity.dart';

abstract class TeamsRepository {
  Future<Either<String, List<TeamEntity>>> getAllTeams(TeamsFilterEntity filter);

}