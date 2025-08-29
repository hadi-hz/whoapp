import 'package:test3/features/get_alert_by_id/data/datasource/visited_by_admin_datasource.dart';
import 'package:test3/features/get_alert_by_id/data/model/visited_by_admin_model.dart';
import 'package:test3/features/get_alert_by_id/domain/entities/visited_by_admin.dart';
import 'package:test3/features/get_alert_by_id/domain/repositories/visited_by_admin.dart';

class VisitedByAdminRepositoryImpl implements VisitedByAdminRepository {
  final VisitedByAdminRemoteDataSource remoteDataSource;

  VisitedByAdminRepositoryImpl(this.remoteDataSource);

  @override
  Future<VisitedByAdminResponse> visitedByAdmin(VisitedByAdminRequest request) async {
    final model = VisitedByAdminModel.fromRequest(request);
    final responseModel = await remoteDataSource.visitedByAdmin(model);
    return responseModel.toEntity();
  }
}