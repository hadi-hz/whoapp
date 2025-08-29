import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/features/get_alert_by_id/data/model/update_by_admin_model.dart';
import 'package:test3/features/get_alert_by_id/data/model/update_by_admin_response_model.dart';

abstract class UpdateAlertByAdminRemoteDataSource {
  Future<UpdateAlertByAdminResponseModel> updateAlertByAdmin(UpdateAlertByAdminModel model);
}

class UpdateAlertByAdminRemoteDataSourceImpl implements UpdateAlertByAdminRemoteDataSource {
  final Dio dio;
 
  UpdateAlertByAdminRemoteDataSourceImpl(this.dio);

  @override
  Future<UpdateAlertByAdminResponseModel> updateAlertByAdmin(UpdateAlertByAdminModel model) async {
    try {
      final response = await dio.post(
        ApiEndpoints.alertUpdateAdmin,
        data: model.toJson(),
      );
      return UpdateAlertByAdminResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update alert by admin: $e');
    }
  }
}
