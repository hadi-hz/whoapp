
import 'package:test3/features/home/domain/entities/chart_funnel_entity.dart';

class FunnelChartModel extends FunnelChartEntity {
  FunnelChartModel({
    required int total,
    required List<FunnelChartStepModel> steps,
  }) : super(
    total: total,
    steps: steps,
  );

  factory FunnelChartModel.fromJson(Map<String, dynamic> json) {
    return FunnelChartModel(
      total: json['total'] ?? 0,
      steps: (json['steps'] as List<dynamic>?)
          ?.map((step) => FunnelChartStepModel.fromJson(step))
          .toList() ?? [],
    );
  }
}

class FunnelChartStepModel extends FunnelChartStepEntity {
  FunnelChartStepModel({
    required String status,
    required int count,
  }) : super(
    status: status,
    count: count,
  );

  factory FunnelChartStepModel.fromJson(Map<String, dynamic> json) {
    return FunnelChartStepModel(
      status: json['status'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}