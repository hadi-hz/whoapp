import 'package:dartz/dartz.dart';
import 'package:test3/features/home/domain/entities/chart_donut_entity.dart';
import 'package:test3/features/home/domain/repositories/chart_repository.dart';
import '../entities/chart_filter_entity.dart';

class GetDonutChartUseCase {
  final ChartsRepository repository;

  GetDonutChartUseCase({required this.repository});

  Future<Either<String, DonutChartEntity>> call(ChartFilterEntity filter) async {
    return await repository.getDonutChartData(filter);
  }
}