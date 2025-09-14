import '../../domain/entities/chart_filter_entity.dart';

class ChartFilterModel extends ChartFilterEntity {
  ChartFilterModel({DateTime? startDate, DateTime? endDate})
    : super(startDate: startDate, endDate: endDate);

  Map<String, dynamic> toQueryParams() {
    Map<String, dynamic> params = {};

    if (startDate != null) {
      params['StartDate'] = startDate!.toIso8601String();
    }
    if (endDate != null) {
      params['EndDate'] = endDate!.toIso8601String();
    }

    return params;
  }
}
