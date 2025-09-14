import 'package:dartz/dartz.dart';
import 'package:test3/features/home/domain/entities/chart_bar_entity.dart';
import 'package:test3/features/home/domain/entities/chart_donut_entity.dart';
import 'package:test3/features/home/domain/entities/chart_funnel_entity.dart';
import '../entities/chart_filter_entity.dart';


abstract class ChartsRepository {
  Future<Either<String, DonutChartEntity>> getDonutChartData(ChartFilterEntity filter);
  Future<Either<String, FunnelChartEntity>> getFunnelChartData(ChartFilterEntity filter);
  Future<Either<String, BarChartEntity>> getBarChartData(ChartFilterEntity filter);
}