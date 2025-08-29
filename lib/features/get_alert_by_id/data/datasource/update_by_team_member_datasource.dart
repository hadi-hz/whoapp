import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/features/get_alert_by_id/data/model/update_by_team_member_model.dart';
import 'package:test3/features/get_alert_by_id/data/model/update_by_team_member_response_model.dart';

abstract class UpdateAlertByTeamMemberRemoteDataSource {
  Future<UpdateAlertByTeamMemberResponseModel> updateAlertByTeamMember(UpdateAlertByTeamMemberModel model);
}

class UpdateAlertByTeamMemberRemoteDataSourceImpl implements UpdateAlertByTeamMemberRemoteDataSource {
  final Dio dio;

  UpdateAlertByTeamMemberRemoteDataSourceImpl(this.dio);

  @override
  Future<UpdateAlertByTeamMemberResponseModel> updateAlertByTeamMember(UpdateAlertByTeamMemberModel model) async {
    try {
      final response = await dio.post(
        ApiEndpoints.alertUpdateteammember,
        data: model.toJson(),
      );
      return UpdateAlertByTeamMemberResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update alert by team member: $e');
    }
  }
}