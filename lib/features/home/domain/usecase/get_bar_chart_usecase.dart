import 'package:dartz/dartz.dart';
import 'package:test3/features/home/domain/entities/chart_bar_entity.dart';
import 'package:test3/features/home/domain/repositories/chart_repository.dart';
import '../entities/chart_filter_entity.dart';

class GetBarChartUseCase {
  final ChartsRepository repository;

  GetBarChartUseCase({required this.repository});

  Future<Either<String, BarChartEntity>> call(ChartFilterEntity filter) async {
    return await repository.getBarChartData(filter);
  }
}
