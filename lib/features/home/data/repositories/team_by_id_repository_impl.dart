import 'package:dartz/dartz.dart';
import 'package:test3/features/home/data/datasource/get_team_by_id.dart';
import 'package:test3/features/home/domain/repositories/team_by_id_repository.dart';
import '../../domain/entities/team_by_id_response_entity.dart';


class GetTeamByIdRepositoryImpl implements GetTeamByIdRepository {
  final GetTeamByIdRemoteDataSource remoteDataSource;

  GetTeamByIdRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, TeamByIdResponseEntity>> getTeamById(String teamId) async {
    try {
      final result = await remoteDataSource.getTeamById(teamId);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}