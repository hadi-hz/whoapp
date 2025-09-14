// charts_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:test3/features/home/data/datasource/chart_datasource.dart';
import 'package:test3/features/home/domain/entities/chart_bar_entity.dart';
import 'package:test3/features/home/domain/entities/chart_donut_entity.dart';
import 'package:test3/features/home/domain/entities/chart_funnel_entity.dart';
import 'package:test3/features/home/domain/repositories/chart_repository.dart';
import '../../domain/entities/chart_filter_entity.dart';
import '../model/chart_filter_model.dart';

class ChartsRepositoryImpl implements ChartsRepository {
  final ChartsRemoteDataSource remoteDataSource;

  ChartsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, DonutChartEntity>> getDonutChartData(
    ChartFilterEntity filter,
  ) async {
    try {
      final filterModel = ChartFilterModel(
        startDate: filter.startDate,
        endDate: filter.endDate,
      );

      final result = await remoteDataSource.getDonutChartData(filterModel);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, FunnelChartEntity>> getFunnelChartData(
    ChartFilterEntity filter,
  ) async {
    try {
      final filterModel = ChartFilterModel(
        startDate: filter.startDate,
        endDate: filter.endDate,
      );

      final result = await remoteDataSource.getFunnelChartData(filterModel);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, BarChartEntity>> getBarChartData(
    ChartFilterEntity filter,
  ) async {
    try {
      final filterModel = ChartFilterModel(
        startDate: filter.startDate,
        endDate: filter.endDate,
      );

      final result = await remoteDataSource.getBarChartData(filterModel);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
