// chart_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/features/home/domain/entities/chart_bar_entity.dart';
import 'package:test3/features/home/domain/entities/chart_donut_entity.dart';
import 'package:test3/features/home/domain/entities/chart_filter_entity.dart';
import 'package:test3/features/home/domain/entities/chart_funnel_entity.dart';
import 'package:test3/features/home/domain/usecase/get_bar_chart_usecase.dart';
import 'package:test3/features/home/domain/usecase/get_donut_chart_usecase.dart';
import 'package:test3/features/home/domain/usecase/get_funnel_chart_usecase.dart';

class ChartController extends GetxController {
  final GetDonutChartUseCase getDonutChartUseCase;
  final GetFunnelChartUseCase getFunnelChartUseCase;
  final GetBarChartUseCase getBarChartUseCase;

  ChartController({
    required this.getDonutChartUseCase,
    required this.getFunnelChartUseCase,
    required this.getBarChartUseCase,
  });

  // Loading states
  var isLoadingDonut = false.obs;
  var isLoadingFunnel = false.obs;
  var isLoadingBar = false.obs;

  // Error states
  var donutError = ''.obs;
  var funnelError = ''.obs;
  var barError = ''.obs;

  // Data
  Rxn<DonutChartEntity> donutData = Rxn<DonutChartEntity>();
  Rxn<FunnelChartEntity> funnelData = Rxn<FunnelChartEntity>();
  Rxn<BarChartEntity> barData = Rxn<BarChartEntity>();

  // Date filters
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    loadAllCharts();
  }

  // Load all charts
  Future<void> loadAllCharts() async {
    await Future.wait([loadDonutChart(), loadFunnelChart(), loadBarChart()]);
  }

  // Donut Chart Methods
  Future<void> loadDonutChart() async {
    isLoadingDonut.value = true;
    donutError.value = '';

    final filter = ChartFilterEntity(
      startDate: startDate.value,
      endDate: endDate.value,
    );

    final result = await getDonutChartUseCase(filter);

    result.fold(
      (error) {
        donutError.value = error;
        donutData.value = null;
        Get.snackbar(
          'error'.tr,
          'donut_chart_error'.tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      (data) {
        donutData.value = data;
        donutError.value = '';
      },
    );

    isLoadingDonut.value = false;
  }

  // Funnel Chart Methods
  Future<void> loadFunnelChart() async {
    isLoadingFunnel.value = true;
    funnelError.value = '';

    final filter = ChartFilterEntity(
      startDate: startDate.value,
      endDate: endDate.value,
    );

    final result = await getFunnelChartUseCase(filter);

    result.fold(
      (error) {
        funnelError.value = error;
        funnelData.value = null;
        Get.snackbar(
          'error'.tr,
          'funnel_chart_error'.tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      (data) {
        funnelData.value = data;
        funnelError.value = '';
      },
    );

    isLoadingFunnel.value = false;
  }

  // Bar Chart Methods
  Future<void> loadBarChart() async {
    isLoadingBar.value = true;
    barError.value = '';

    final filter = ChartFilterEntity(
      startDate: startDate.value,
      endDate: endDate.value,
    );

    final result = await getBarChartUseCase(filter);

    result.fold(
      (error) {
        barError.value = error;
        barData.value = null;
        Get.snackbar(
          'error'.tr,
          'bar_chart_error'.tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      (data) {
        barData.value = data;
        barError.value = '';
      },
    );

    isLoadingBar.value = false;
  }

  // Date filter methods
  void setStartDate(DateTime? date) {
    startDate.value = date;
  }

  void setEndDate(DateTime? date) {
    endDate.value = date;
  }

  void clearDateFilter() {
    startDate.value = null;
    endDate.value = null;
    loadAllCharts();
  }

  void applyDateFilter() {
    loadAllCharts();
  }

  // Refresh methods
  Future<void> refreshDonutChart() async {
    await loadDonutChart();
  }

  Future<void> refreshFunnelChart() async {
    await loadFunnelChart();
  }

  Future<void> refreshBarChart() async {
    await loadBarChart();
  }

  Future<void> refreshAllCharts() async {
    await loadAllCharts();
  }
}
