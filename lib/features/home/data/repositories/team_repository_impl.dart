import 'package:dartz/dartz.dart';
import 'package:test3/features/home/data/datasource/team_datasource.dart';
import 'package:test3/features/home/data/model/team_filter_model.dart';
import 'package:test3/features/home/domain/entities/team_filter_entity.dart';
import 'package:test3/features/home/domain/repositories/team_repository.dart';
import '../../domain/entities/team_entity.dart';


class TeamsRepositoryImpl implements TeamsRepository {
  final TeamsRemoteDataSource remoteDataSource;



  TeamsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<TeamEntity>>> getAllTeams(TeamsFilterEntity filter) async {
    try {
      final filterModel = TeamsFilterModel(
        name: filter.name,
        isHealthcareCleaningAndDisinfection: filter.isHealthcareCleaningAndDisinfection,
        isHouseholdCleaningAndDisinfection: filter.isHouseholdCleaningAndDisinfection,
        isPatientsReferral: filter.isPatientsReferral,
        isSafeAndDignifiedBurial: filter.isSafeAndDignifiedBurial,
      );

      final result = await remoteDataSource.getAllTeams(filterModel);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }


    
  }


}
