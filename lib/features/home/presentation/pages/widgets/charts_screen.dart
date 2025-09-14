import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/home/presentation/controller/charts_controller.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChartController controller = Get.find<ChartController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[50],
      body: Container(
        
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppColors.primaryColor.withOpacity(0.3),
                    AppColors.primaryColor.withOpacity(0.1),
                    Colors.black,
                  ]
                : [AppColors.primaryColor.withOpacity(0.1), Colors.white],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () => controller.refreshAllCharts(),
          color: AppColors.primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsetsDirectional.only(top: 54 , end: 24 , start: 24 , bottom:  124),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isDark, isTablet),
                SizedBox(height: isTablet ? 32 : 24),
                _buildDateFilters(controller, isDark, isTablet, context),
                SizedBox(height: isTablet ? 32 : 24),
                _buildChartsGrid(controller, isDark, isTablet),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[850]?.withOpacity(0.8)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: isTablet ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 12 : 10),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
            ),
            child: Icon(
              Icons.analytics_outlined,
              color: AppColors.primaryColor,
              size: isTablet ? 32 : 24,
            ),
          ),
          SizedBox(width: isTablet ? 16 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'analytics_dashboard'.tr,
                  style: TextStyle(
                    fontSize: isTablet ? 24 : 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: isTablet ? 6 : 4),
                Text(
                  'comprehensive_reports'.tr,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilters(
    ChartController controller,
    bool isDark,
    bool isTablet,
    BuildContext context,
  ) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[850]?.withOpacity(0.8)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: isTablet ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.date_range,
                color: AppColors.primaryColor,
                size: isTablet ? 24 : 20,
              ),
              SizedBox(width: isTablet ? 12 : 8),
              Text(
                'date_filters'.tr,
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 20 : 16),
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  label: 'start_date'.tr,
                  value: controller.startDate.value,
                  onTap: () => _selectDate(context, controller, true),
                  isDark: isDark,
                  isTablet: isTablet,
                ),
              ),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(
                child: _buildDateField(
                  label: 'end_date'.tr,
                  value: controller.endDate.value,
                  onTap: () => _selectDate(context, controller, false),
                  isDark: isDark,
                  isTablet: isTablet,
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 20 : 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => controller.applyDateFilter(),
                  icon: Icon(Icons.search, size: isTablet ? 20 : 18),
                  label: Text(
                    'apply_filter'.tr,
                    style: TextStyle(fontSize: isTablet ? 16 : 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
                    ),
                  ),
                ),
              ),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => controller.clearDateFilter(),
                  icon: Icon(Icons.clear, size: isTablet ? 20 : 18),
                  label: Text(
                    'clear_filter'.tr,
                    style: TextStyle(fontSize: isTablet ? 16 : 14),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? Colors.white70 : Colors.grey[700],
                    side: BorderSide(
                      color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                    padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
    required bool isDark,
    required bool isTablet,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[50],
          borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
          border: Border.all(
            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isTablet ? 14 : 12,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: isTablet ? 8 : 6),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: isTablet ? 20 : 16,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                SizedBox(width: isTablet ? 8 : 6),
                Expanded(
                  child: Text(
                    value != null
                        ? '${value.day}/${value.month}/${value.year}'
                        : 'select_date'.tr,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: value != null
                          ? (isDark ? Colors.white : Colors.black)
                          : (isDark ? Colors.grey[500] : Colors.grey[500]),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsGrid(
    ChartController controller,
    bool isDark,
    bool isTablet,
  ) {
    return Column(
      children: [
        // Donut Chart
        _buildChartCard(
          title: 'alert_types_distribution'.tr,
          icon: Icons.donut_small,
          child: Obx(() {
            if (controller.isLoadingDonut.value) {
              return _buildLoadingChart(isTablet);
            }
            if (controller.donutError.value.isNotEmpty) {
              return _buildErrorChart(
                controller.donutError.value,
                () => controller.refreshDonutChart(),
                isTablet,
              );
            }
            if (controller.donutData.value == null) {
              return _buildEmptyChart('no_data_available'.tr, isTablet);
            }
            return _buildDonutChart(
              controller.donutData.value!,
              isDark,
              isTablet,
            );
          }),
          isDark: isDark,
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 24 : 16),

        // Funnel Chart
        _buildChartCard(
          title: 'alert_status_pipeline'.tr,
          icon: Icons.filter_list,
          child: Obx(() {
            if (controller.isLoadingFunnel.value) {
              return _buildLoadingChart(isTablet);
            }
            if (controller.funnelError.value.isNotEmpty) {
              return _buildErrorChart(
                controller.funnelError.value,
                () => controller.refreshFunnelChart(),
                isTablet,
              );
            }
            if (controller.funnelData.value == null) {
              return _buildEmptyChart('no_data_available'.tr, isTablet);
            }
            return _buildFunnelChart(
              controller.funnelData.value!,
              isDark,
              isTablet,
            );
          }),
          isDark: isDark,
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 24 : 16),

        // Bar Chart
        _buildChartCard(
          title: 'alerts_by_doctors'.tr,
          icon: Icons.bar_chart,
          child: Obx(() {
            if (controller.isLoadingBar.value) {
              return _buildLoadingChart(isTablet);
            }
            if (controller.barError.value.isNotEmpty) {
              return _buildErrorChart(
                controller.barError.value,
                () => controller.refreshBarChart(),
                isTablet,
              );
            }
            if (controller.barData.value == null) {
              return _buildEmptyChart('no_data_available'.tr, isTablet);
            }
            return _buildBarChart(controller.barData.value!, isDark, isTablet);
          }),
          isDark: isDark,
          isTablet: isTablet,
        ),
      ],
    );
  }

  Widget _buildChartCard({
    required String title,
    required IconData icon,
    required Widget child,
    required bool isDark,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[850]?.withOpacity(0.8)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: isTablet ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 10 : 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryColor,
                  size: isTablet ? 24 : 20,
                ),
              ),
              SizedBox(width: isTablet ? 12 : 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 20 : 16),
          child,
        ],
      ),
    );
  }

  Widget _buildDonutChart(dynamic donutData, bool isDark, bool isTablet) {
    return SizedBox(
      height: isTablet ? 350 : 300,
      child: SfCircularChart(
        title: ChartTitle(
          text: 'total_alerts'.tr + ': ${donutData.total}',
          textStyle: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
            fontSize: isTablet ? 14 : 12,
          ),
        ),
        series: <CircularSeries>[
          DoughnutSeries<dynamic, String>(
            dataSource: donutData.types,
            xValueMapper: (data, _) => data.type,
            yValueMapper: (data, _) => data.count,
            dataLabelMapper: (data, _) => '${data.percent.toStringAsFixed(1)}%',
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 12 : 10,
              ),
            ),
            enableTooltip: true,
            pointColorMapper: (data, index) => _getChartColor(index),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _buildFunnelChart(dynamic funnelData, bool isDark, bool isTablet) {
    return SizedBox(
      height: isTablet ? 400 : 350,
      child: SfCartesianChart(
        title: ChartTitle(
          text: 'total_alerts'.tr + ': ${funnelData.total}',
          textStyle: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        primaryXAxis: CategoryAxis(
          labelStyle: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
            fontSize: isTablet ? 12 : 10,
          ),
          labelRotation: -45,
        ),
        primaryYAxis: NumericAxis(
          labelStyle: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
            fontSize: isTablet ? 12 : 10,
          ),
        ),
        series: <CartesianSeries>[
          ColumnSeries<dynamic, String>(
            dataSource: funnelData.steps,
            xValueMapper: (data, _) => data.status,
            yValueMapper: (data, _) => data.count,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 12 : 10,
              ),
            ),
            enableTooltip: true,
            pointColorMapper: (data, index) => _getChartColor(index),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _buildBarChart(dynamic barData, bool isDark, bool isTablet) {
    return SizedBox(
      height: isTablet ? 350 : 300,
      child: SfCartesianChart(
        title: ChartTitle(
          text: 'total_alerts'.tr + ': ${barData.total}',
          textStyle: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        primaryXAxis: CategoryAxis(
          labelStyle: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
            fontSize: isTablet ? 12 : 10,
          ),
          labelRotation: -45,
        ),
        primaryYAxis: NumericAxis(
          labelStyle: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
            fontSize: isTablet ? 12 : 10,
          ),
        ),
        series: <CartesianSeries>[
          BarSeries<dynamic, String>(
            dataSource: barData.doctors,
            xValueMapper: (data, _) => data.doctorName,
            yValueMapper: (data, _) => data.count,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 12 : 10,
              ),
            ),
            enableTooltip: true,
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _buildLoadingChart(bool isTablet) {
    return SizedBox(
      height: isTablet ? 300 : 250,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primaryColor),
            SizedBox(height: isTablet ? 16 : 12),
            Text(
              'loading_chart'.tr,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorChart(String error, VoidCallback onRetry, bool isTablet) {
    return SizedBox(
      height: isTablet ? 300 : 250,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: isTablet ? 64 : 48,
              color: Colors.red,
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Text(
              'chart_error'.tr,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh),
              label: Text('retry'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyChart(String message, bool isTablet) {
    return SizedBox(
      height: isTablet ? 300 : 250,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bubble_chart_outlined,
              size: isTablet ? 64 : 48,
              color: Colors.grey[400],
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Text(
              message,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getChartColor(int index) {
    final colors = [
      AppColors.primaryColor,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.blue,
      Colors.teal,
      Colors.pink,
    ];
    return colors[index % colors.length];
  }

  Future<void> _selectDate(
    BuildContext context,
    ChartController controller,
    bool isStartDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      if (isStartDate) {
        controller.setStartDate(picked);
      } else {
        controller.setEndDate(picked);
      }
    }
  }
}
