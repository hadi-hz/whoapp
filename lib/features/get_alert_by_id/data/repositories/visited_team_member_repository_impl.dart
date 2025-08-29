import 'package:test3/features/get_alert_by_id/data/datasource/visited_by_team_member_datasource.dart';
import 'package:test3/features/get_alert_by_id/data/model/visited_by_team_member_model.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/visited_by_team_member.dart';
import 'package:test3/features/get_alert_by_id/domain/repositories/visited_by_team_member.dart';

class VisitedByTeamMemberRepositoryImpl implements VisitedByTeamMemberRepository {
  final VisitedByTeamMemberRemoteDataSource remoteDataSource;

  VisitedByTeamMemberRepositoryImpl(this.remoteDataSource);

  @override
  Future<VisitedByTeamMemberResponse> visitedByTeamMember(VisitedByTeamMemberRequest request) async {
    final model = VisitedByTeamMemberModel.fromRequest(request);
    final responseModel = await remoteDataSource.visitedByTeamMember(model);
    return responseModel.toEntity();
  }
}