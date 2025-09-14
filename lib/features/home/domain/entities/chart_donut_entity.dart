class DonutChartEntity {
  final int total;
  final List<DonutChartTypeEntity> types;

  DonutChartEntity({
    required this.total,
    required this.types,
  });
}

class DonutChartTypeEntity {
  final String type;
  final int count;
  final double percent;

  DonutChartTypeEntity({
    required this.type,
    required this.count,
    required this.percent,
  });
}