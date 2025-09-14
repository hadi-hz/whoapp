class FunnelChartEntity {
  final int total;
  final List<FunnelChartStepEntity> steps;

  FunnelChartEntity({
    required this.total,
    required this.steps,
  });
}

class FunnelChartStepEntity {
  final String status;
  final int count;

  FunnelChartStepEntity({
    required this.status,
    required this.count,
  });
}