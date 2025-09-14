import 'package:dartz/dartz.dart';
import 'package:test3/features/home/domain/entities/chart_funnel_entity.dart';
import 'package:test3/features/home/domain/repositories/chart_repository.dart';
import '../entities/chart_filter_entity.dart';


class GetFunnelChartUseCase {
  final ChartsRepository repository;

  GetFunnelChartUseCase({required this.repository});

  Future<Either<String, FunnelChartEntity>> call(ChartFilterEntity filter) async {
    return await repository.getFunnelChartData(filter);
  }
}