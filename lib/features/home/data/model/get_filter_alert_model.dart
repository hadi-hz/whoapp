import 'package:test3/features/home/domain/entities/get_filter_alert.dart';


class AlertFilterModel extends AlertFilterEntity {
  AlertFilterModel({
    super.search,
    super.userId,
    super.status,
    super.type,
    super.registerDateFrom,
    super.registerDateTo,
    super.sortBy,
    super.sortDescending,
    super.teamId,
    super.page,
    super.pageSize,
  });

  Map<String, dynamic> toQueryParams() {
    Map<String, dynamic> params = {};

    if (search != null && search!.isNotEmpty) params['Search'] = search;
    if (userId != null) params['UserId'] = userId;
    if (status != null) params['Status'] = status;
    if (type != null) params['Type'] = type;
    if (registerDateFrom != null) params['RegisterDateFrom'] = registerDateFrom!.toIso8601String();
    if (registerDateTo != null) params['RegisterDateTo'] = registerDateTo!.toIso8601String();
    if (sortBy != null) params['SortBy'] = sortBy;
    if (sortDescending != null) params['SortDescending'] = sortDescending;
    if (teamId != null) params['TeamId'] = teamId;
    params['Page'] = page;
    params['PageSize'] = pageSize;

    return params;
  }
}
