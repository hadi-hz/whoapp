import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/get_alert_by_id/presentation/pages/get_alert_detail.dart';
import 'package:test3/features/home/presentation/controller/get_alert_controller.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/home/presentation/pages/widgets/drop_down_widget.dart';

class ReportsPage extends StatefulWidget {
  ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final TextEditingController search = TextEditingController();
  final controller = Get.find<AuthController>();
  final HomeController homeController = Get.find<HomeController>();
  final AlertListController alertController = Get.find<AlertListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.width,
        height: context.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor.withOpacity(0.4),
              AppColors.primaryColor.withOpacity(0.35),
              AppColors.primaryColor.withOpacity(0.3),
              AppColors.primaryColor.withOpacity(0.25),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
              AppColors.primaryColor.withOpacity(0),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 16,
            end: 16,
            start: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstantSpace.largeVerticalSpacer,
                ConstantSpace.largeVerticalSpacer,
                profileHeader(),
                ConstantSpace.mediumVerticalSpacer,
                searching(context, search),
                ConstantSpace.mediumVerticalSpacer,
                buildExpandableFiltersContainer(),
                ConstantSpace.mediumVerticalSpacer,
                SizedBox(
                  height: context.height * 0.59,
                  child: Obx(() {
                    if (alertController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (alertController.hasError.value) {
                      return Center(
                        child: Text(alertController.errorMessage.value),
                      );
                    }

                    if (alertController.alerts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text('no_reports_found'.tr),
                            if (alertController
                                .searchQuery
                                .value
                                .isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                '${'no_results_for'.tr} "${alertController.searchQuery.value}"',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            if (alertController.selectedStatus.value != null ||
                                alertController.selectedType.value != null ||
                                alertController
                                    .searchQuery
                                    .value
                                    .isNotEmpty) ...[
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  search.clear();
                                  alertController.clearFilters();
                                },
                                child: Text('clear_filters'.tr),
                              ),
                            ],
                          ],
                        ),
                      );
                    }

                    Map<String, dynamic> getStatusData(int status) {
                      switch (status) {
                        case 0:
                          return {'name': 'initial'.tr, 'color': Colors.green};
                        case 1:
                          return {
                            'name': 'visited_by_admin'.tr,
                            'color': Colors.blue,
                          };
                        case 2:
                          return {
                            'name': 'assigned_to_team'.tr,
                            'color': Colors.orange,
                          };
                        case 3:
                          return {
                            'name': 'visited_by_team_member'.tr,
                            'color': Colors.purple,
                          };
                        case 4:
                          return {
                            'name': 'team_start_processing'.tr,
                            'color': Colors.teal,
                          };
                        case 5:
                          return {
                            'name': 'team_finish_processing'.tr,
                            'color': Colors.yellow,
                          };
                        case 6:
                          return {
                            'name': 'admin_close'.tr,
                            'color': Colors.red,
                          };
                        default:
                          return {'name': 'Unknown', 'color': Colors.black};
                      }
                    }

                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,

                        children: alertController.alerts.map((alert) {
                          final statusData = getStatusData(alert.alertStatus);

                          return IntrinsicHeight(
                            child: GestureDetector(
                              onTap: () {
                                Get.to(
                                  AlertDetailPage(
                                    alertId: alert.id,
                                    alertType: alert.alertType,
                                  ),
                                );
                              },
                              child: Container(
                                width:
                                    (MediaQuery.of(context).size.width - 44) /
                                    2,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    width: 2,
                                    color: AppColors.borderColor,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.person, size: 16),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            alert.doctorName,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.groups_2, size: 16),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            alert.teamName ?? 'no_team'.tr,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month_rounded,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            DateFormat(
                                              'yyyy-MM-dd',
                                            ).format(alert.serverCreateTime),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusData['color'].withOpacity(
                                          0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: statusData['color'],
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        statusData['name'],
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: statusData['color'],
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searching(BuildContext context, TextEditingController controller) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          alertController.onSearchChanged(value);
        },
        decoration: InputDecoration(
          hintText: 'search_by_doctor_team'.tr,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          suffixIcon: Obx(() {
            if (alertController.searchQuery.value.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.clear, size: 20, color: Colors.grey),
                onPressed: () {
                  controller.clear();
                  alertController.onSearchChanged("");
                },
              );
            }
            return const Icon(Icons.search, color: Colors.grey);
          }),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget buildExpandableFiltersContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              homeController.toggleFiltersExpansion();
            },
            child: Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: homeController.isFiltersExpanded.value
                      ? const BorderRadius.vertical(top: Radius.circular(16))
                      : BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'filters'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const Spacer(),
                    Obx(() {
                      int activeFilters = 0;

                      if (alertController.selectedStatus.value != null)
                        activeFilters++;
                      if (alertController.selectedType.value != null)
                        activeFilters++;
                      if (alertController.searchQuery.value.isNotEmpty)
                        activeFilters++;

                      return activeFilters > 0
                          ? Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$activeFilters',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : const SizedBox.shrink();
                    }),
                    AnimatedRotation(
                      turns: homeController.isFiltersExpanded.value ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.expand_more,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: homeController.isFiltersExpanded.value ? null : 0,
              child: AnimatedOpacity(
                opacity: homeController.isFiltersExpanded.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: homeController.isFiltersExpanded.value
                    ? buildFiltersContent()
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFiltersContent() {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Row(
          children: [
            Expanded(
              child: DropdownFilter(
                hint: 'filter_by_status'.tr,
                selectedValue: alertController.selectedStatus.value,
          
                items: alertController.statusOptions,
                onChanged: (value) => alertController.onStatusChanged(value),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownFilter(
                hint: 'filter_by_type'.tr,
                selectedValue: alertController.selectedType.value,
            
                items: alertController.typeOptions,
                onChanged: (value) => alertController.onTypeChanged(value),
              ),
            ),
          ],
        )),

        const SizedBox(height: 16),

        TextFormField(
          onChanged: (value) =>
              alertController.onUserIdChanged(value.isEmpty ? null : value),
          decoration: InputDecoration(
            hintText: 'filter_by_user_id'.tr,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            suffixIcon: Obx(
              () => alertController.selectedUserId.value != null
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () => alertController.onUserIdChanged(null),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),

        const SizedBox(height: 16),

        TextFormField(
          onChanged: (value) =>
              alertController.onTeamIdChanged(value.isEmpty ? null : value),
          decoration: InputDecoration(
            hintText: 'filter_by_team_id'.tr,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            suffixIcon: Obx(
              () => alertController.selectedTeamId.value != null
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () => alertController.onTeamIdChanged(null),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Text(
          'date_range_filter'.tr,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(context, isFromDate: true),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Obx(
                          () => Text(
                            alertController.dateFrom.value != null
                                ? DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(alertController.dateFrom.value!)
                                : 'from_date'.tr,
                            style: TextStyle(
                              fontSize: 14,
                              color: alertController.dateFrom.value != null
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      if (alertController.dateFrom.value != null)
                        GestureDetector(
                          onTap: () => alertController.onDateRangeChanged(
                            null,
                            alertController.dateTo.value,
                          ),
                          child: const Icon(
                            Icons.clear,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(context, isFromDate: false),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Obx(
                          () => Text(
                            alertController.dateTo.value != null
                                ? DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(alertController.dateTo.value!)
                                : 'to_date'.tr,
                            style: TextStyle(
                              fontSize: 14,
                              color: alertController.dateTo.value != null
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      if (alertController.dateTo.value != null)
                        GestureDetector(
                          onTap: () => alertController.onDateRangeChanged(
                            alertController.dateFrom.value,
                            null,
                          ),
                          child: const Icon(
                            Icons.clear,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Text(
          'sort_options'.tr,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: Obx(
                    () => DropdownButton<String>(
                      isExpanded: true,
                      value: alertController.sortBy.value,
                      hint: Text('sort_by'.tr),
                      onChanged: (value) => alertController.onSortChanged(
                        value ?? 'serverCreateTime',
                        alertController.sortDescending.value,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'serverCreateTime',
                          child: Text('date'.tr),
                        ),
                        DropdownMenuItem(
                          value: 'doctorName',
                          child: Text('doctor_name'.tr),
                        ),
                        DropdownMenuItem(
                          value: 'alertStatus',
                          child: Text('status'.tr),
                        ),
                        DropdownMenuItem(
                          value: 'alertType',
                          child: Text('type'.tr),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Obx(
              () => GestureDetector(
                onTap: () => alertController.onSortChanged(
                  alertController.sortBy.value,
                  !alertController.sortDescending.value,
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(12),
                    color: alertController.sortDescending.value
                        ? AppColors.primaryColor.withOpacity(0.1)
                        : Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        alertController.sortDescending.value
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        size: 16,
                        color: alertController.sortDescending.value
                            ? AppColors.primaryColor
                            : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        alertController.sortDescending.value
                            ? 'desc'.tr
                            : 'asc'.tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: alertController.sortDescending.value
                              ? AppColors.primaryColor
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  search.clear();
                  alertController.clearFilters();
                },
                icon: const Icon(Icons.clear_all, size: 18),
                label: Text('clear_all_filters'.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  foregroundColor: Colors.grey[700],
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => alertController.refreshAlerts(),
                icon: const Icon(Icons.refresh, size: 18),
                label: Text('apply_filters'.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
  Future<void> _selectDate(
    BuildContext context, {
    required bool isFromDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      if (isFromDate) {
        alertController.onDateRangeChanged(
          picked,
          alertController.dateTo.value,
        );
      } else {
        alertController.onDateRangeChanged(
          alertController.dateFrom.value,
          picked,
        );
      }
    }
  }

  Widget profileHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'hello'.tr,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            ConstantSpace.smallVerticalSpacer,
            Obx(() {
              return Text(
                '${controller.userName?.value ?? ''}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              );
            }),
          ],
        ),
        const Spacer(),
        Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(54),
            color: AppColors.backgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.notifications_none_rounded),
                ConstantSpace.mediumHorizontalSpacer,
                CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  radius: 24,
                  child: Icon(Icons.person, color: AppColors.backgroundColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
