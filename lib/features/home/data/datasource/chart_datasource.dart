import 'package:dio/dio.dart';
import 'package:test3/core/network/api_endpoints.dart';
import 'package:test3/core/network/dio_baseurl.dart';
import '../model/chart_filter_model.dart';
import '../model/donut_chart_model.dart';
import '../model/funnel_chart_model.dart';
import '../model/bar_chart_model.dart';

abstract class ChartsRemoteDataSource {
  Future<DonutChartModel> getDonutChartData(ChartFilterModel filter);
  Future<FunnelChartModel> getFunnelChartData(ChartFilterModel filter);
  Future<BarChartModel> getBarChartData(ChartFilterModel filter);
}

class ChartsRemoteDataSourceImpl implements ChartsRemoteDataSource {
  final Dio _dio = DioBase().dio;

  ChartsRemoteDataSourceImpl();

  @override
  Future<DonutChartModel> getDonutChartData(ChartFilterModel filter) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.donutChart,
        queryParameters: filter.toQueryParams(),
        options: Options(
          headers: {'Content-Type': 'application/json', 'accept': '*/*'},
        ),
        data: '',
      );

      if (response.statusCode == 200) {
        return DonutChartModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get donut chart data: ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(
          'Server error: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error getting donut chart data: $e');
    }
  }

  @override
  Future<FunnelChartModel> getFunnelChartData(ChartFilterModel filter) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.funnelChart,
        queryParameters: filter.toQueryParams(),
        options: Options(
          headers: {'Content-Type': 'application/json', 'accept': '*/*'},
        ),
        data: '',
      );

      if (response.statusCode == 200) {
        return FunnelChartModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get funnel chart data: ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(
          'Server error: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error getting funnel chart data: $e');
    }
  }

  @override
  Future<BarChartModel> getBarChartData(ChartFilterModel filter) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.barChart,
        queryParameters: filter.toQueryParams(),
        options: Options(
          headers: {'Content-Type': 'application/json', 'accept': '*/*'},
        ),
        data: '',
      );

      if (response.statusCode == 200) {
        return BarChartModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get bar chart data: ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(
          'Server error: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error getting bar chart data: $e');
    }
  }
}