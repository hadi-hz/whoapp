import 'package:test3/features/get_alert_by_id/domain/entities/visited_by_admin.dart';

abstract class VisitedByAdminRepository {
  Future<VisitedByAdminResponse> visitedByAdmin(VisitedByAdminRequest request);
}
