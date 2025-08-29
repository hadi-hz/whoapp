import 'package:test3/features/get_alert_by_id/data/datasource/update_by_team_member_datasource.dart';
import 'package:test3/features/get_alert_by_id/data/model/update_by_team_member_model.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/update_by_team_member.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/update_by_team_member_response.dart';
import 'package:test3/features/get_alert_by_id/domain/repositories/update_by_team_member.dart';

class UpdateAlertByTeamMemberRepositoryImpl implements UpdateAlertByTeamMemberRepository {
  final UpdateAlertByTeamMemberRemoteDataSource remoteDataSource;

  UpdateAlertByTeamMemberRepositoryImpl(this.remoteDataSource);

  @override
  Future<UpdateAlertByTeamMemberResponse> updateAlertByTeamMember(UpdateAlertByTeamMemberRequest request) async {
    final model = UpdateAlertByTeamMemberModel.fromRequest(request);
    final responseModel = await remoteDataSource.updateAlertByTeamMember(model);
    return responseModel.toEntity();
  }
}
