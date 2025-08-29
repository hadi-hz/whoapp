import 'package:test3/features/get_alert_by_id/domain/entities/update_by_team_member.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/update_by_team_member_response.dart';
import 'package:test3/features/get_alert_by_id/domain/repositories/update_by_team_member.dart';

class UpdateAlertByTeamMemberUseCase {
  final UpdateAlertByTeamMemberRepository repository;

  UpdateAlertByTeamMemberUseCase(this.repository);

  Future<UpdateAlertByTeamMemberResponse> call(UpdateAlertByTeamMemberRequest request) async {
    return await repository.updateAlertByTeamMember(request);
  }
}