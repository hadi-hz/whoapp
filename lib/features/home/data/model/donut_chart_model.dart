
import 'package:test3/features/home/domain/entities/chart_donut_entity.dart';

class DonutChartModel extends DonutChartEntity {
  DonutChartModel({
    required int total,
    required List<DonutChartTypeModel> types,
  }) : super(
    total: total,
    types: types,
  );

  factory DonutChartModel.fromJson(Map<String, dynamic> json) {
    return DonutChartModel(
      total: json['total'] ?? 0,
      types: (json['types'] as List<dynamic>?)
          ?.map((type) => DonutChartTypeModel.fromJson(type))
          .toList() ?? [],
    );
  }
}

class DonutChartTypeModel extends DonutChartTypeEntity {
  DonutChartTypeModel({
    required String type,
    required int count,
    required double percent,
  }) : super(
    type: type,
    count: count,
    percent: percent,
  );

  factory DonutChartTypeModel.fromJson(Map<String, dynamic> json) {
    return DonutChartTypeModel(
      type: json['type'] ?? '',
      count: json['count'] ?? 0,
      percent: (json['percent'] ?? 0.0).toDouble(),
    );
  }
}
