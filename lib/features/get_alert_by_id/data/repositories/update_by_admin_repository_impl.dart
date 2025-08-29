import 'package:test3/features/get_alert_by_id/data/datasource/update_by_admin_datasource.dart';
import 'package:test3/features/get_alert_by_id/data/model/update_by_admin_model.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/update_by_admin.dart';
import 'package:test3/features/get_alert_by_id/domain/repositories/update_by_admin.dart';

class UpdateAlertByAdminRepositoryImpl implements UpdateAlertByAdminRepository {
  final UpdateAlertByAdminRemoteDataSource remoteDataSource;

  UpdateAlertByAdminRepositoryImpl(this.remoteDataSource);

  @override
  Future<UpdateAlertByAdminResponse> updateAlertByAdmin(UpdateAlertByAdminRequest request) async {
    final model = UpdateAlertByAdminModel.fromRequest(request);
    final responseModel = await remoteDataSource.updateAlertByAdmin(model);
    return responseModel.toEntity();
  }
}