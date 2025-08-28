import 'package:test3/features/home/data/datasource/team_start_processing_datasource.dart';
import 'package:test3/features/home/data/model/team_start_processing_model.dart';
import 'package:test3/features/home/domain/entities/team_start_processing.dart';
import 'package:test3/features/home/domain/repositories/team_start_processing_repository.dart';

class TeamStartProcessingRepositoryImpl implements TeamStartProcessingRepository {
  final TeamStartProcessingRemoteDataSource remoteDataSource;

  TeamStartProcessingRepositoryImpl(this.remoteDataSource);

  @override
  Future<TeamStartProcessingResponse> teamStartProcessing(TeamStartProcessingRequest request) async {
    final model = TeamStartProcessingModel.fromRequest(request);
    final responseModel = await remoteDataSource.teamStartProcessing(model);
    return responseModel.toEntity();
  }
}