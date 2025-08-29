import 'package:test3/features/get_alert_by_id/domain/entities/visited_by_admin.dart';
import 'package:test3/features/get_alert_by_id/domain/repositories/visited_by_admin.dart';

class VisitedByAdminUseCase {
  final VisitedByAdminRepository repository;

  VisitedByAdminUseCase(this.repository);

  Future<VisitedByAdminResponse> call(VisitedByAdminRequest request) async {
    return await repository.visitedByAdmin(request);
  }
}