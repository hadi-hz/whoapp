import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/get_alert_by_id/presentation/pages/get_alert_detail.dart';
import 'package:test3/features/home/presentation/controller/admin_close_alert_controller.dart';
import 'package:test3/features/home/presentation/controller/get_alert_controller.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/home/presentation/pages/widgets/drop_down_widget.dart';
import 'package:test3/features/home/presentation/pages/widgets/notification_page.dart';

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

  void _downloadPDF(String alertId) {
    Get.snackbar(
      'info'.tr,
      'PDF download for alert: $alertId',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _closeAlert(String alertId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedUserId = prefs.getString('userId');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? Colors.grey[850] : Colors.white,
        title: Text(
          'confirm_close'.tr,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        content: Text(
          'are_you_sure_close_alert'.tr,
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'cancel'.tr,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
          Obx(() {
            final adminController = Get.find<AdminCloseAlertController>();
            return ElevatedButton(
              onPressed: adminController.isLoading.value
                  ? null
                  : () async {
                      Get.back();
                      final authController = Get.find<AuthController>();
                      await adminController.closeAlert(
                        alertId,
                        savedUserId ?? '',
                      );
                    },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: adminController.isLoading.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'close_alert'.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: context.width,
        height: context.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppColors.primaryColor.withOpacity(0.3),
                    AppColors.primaryColor.withOpacity(0.2),
                    AppColors.primaryColor.withOpacity(0.1),
                    Colors.black,
                    Colors.black,
                  ]
                : [
                    AppColors.primaryColor.withOpacity(0.4),
                    AppColors.primaryColor.withOpacity(0.35),
                    AppColors.primaryColor.withOpacity(0.3),
                    AppColors.primaryColor.withOpacity(0.25),
                  ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 16,
            end: 16,
            start: 16,
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              alertController.refreshAlerts();
            },
            color: AppColors.primaryColor,
            backgroundColor: isDark ? Colors.grey[800] : Colors.white,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstantSpace.largeVerticalSpacer,
                  ConstantSpace.largeVerticalSpacer,
                  profileHeader(isDark),
                  ConstantSpace.mediumVerticalSpacer,
                  searching(context, search, isDark),
                  ConstantSpace.mediumVerticalSpacer,
                  buildExpandableFiltersContainer(isDark),
                  ConstantSpace.mediumVerticalSpacer,
                  SizedBox(
                    height: context.height * 0.59,
                    child: Obx(() {
                      if (alertController.isLoading.value) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        );
                      }
                      if (alertController.hasError.value) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: isDark ? Colors.red[300] : Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                alertController.errorMessage.value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () =>
                                    alertController.refreshAlerts(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text('retry'.tr),
                              ),
                            ],
                          ),
                        );
                      }
                      if (alertController.alerts.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: isDark ? Colors.grey[400] : Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'no_reports_found'.tr,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black87,
                                ),
                              ),
                              if (alertController
                                  .searchQuery
                                  .value
                                  .isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  '${'no_results_for'.tr} "${alertController.searchQuery.value}"',
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                              if (alertController.selectedStatus.value !=
                                      null ||
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
                            return {
                              'name': 'initial'.tr,
                              'color': homeController.role.value == 'Admin'
                                  ? Colors.red
                                  : Colors.green,
                            };
                          case 1:
                            return {
                              'name': 'visited_by_admin'.tr,
                              'color': homeController.role.value == 'Admin'
                                  ? Colors.orange
                                  : Colors.blue,
                            };
                          case 2:
                            return {
                              'name': 'assigned_to_team'.tr,
                              'color': homeController.role.value == 'Admin'
                                  ? const Color.fromARGB(255, 208, 189, 13)
                                  : homeController.role.value ==
                                        'ServiceProvider'
                                  ? Colors.red
                                  : Colors.orange,
                            };
                          case 3:
                            return {
                              'name': 'visited_by_team_member'.tr,
                              'color': homeController.role.value == 'Admin'
                                  ? const Color.fromARGB(255, 208, 189, 13)
                                  : homeController.role.value ==
                                        'ServiceProvider'
                                  ? const Color.fromARGB(255, 208, 189, 13)
                                  : Colors.purple,
                            };
                          case 4:
                            return {
                              'name': 'team_start_processing'.tr,
                              'color': homeController.role.value == 'Admin'
                                  ? const Color.fromARGB(255, 208, 189, 13)
                                  : homeController.role.value ==
                                        'ServiceProvider'
                                  ? Colors.orange
                                  : Colors.teal,
                            };
                          case 5:
                            return {
                              'name': 'team_finish_processing'.tr,
                              'color': homeController.role.value == 'Admin'
                                  ? Colors.orange
                                  : homeController.role.value ==
                                        'ServiceProvider'
                                  ? const Color.fromARGB(255, 208, 189, 13)
                                  : const Color.fromARGB(255, 208, 189, 13),
                            };
                          case 6:
                            return {
                              'name': 'admin_close'.tr,
                              'color': homeController.role.value == 'Admin'
                                  ? Colors.green
                                  : homeController.role.value ==
                                        'ServiceProvider'
                                  ? Colors.green
                                  : Colors.red,
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
                            return _buildAlertCard(alert, statusData, isDark);
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
      ),
    );
  }

  Widget _buildAlertCard(alert, statusData, bool isDark) {
    return IntrinsicHeight(
      child: GestureDetector(
        onTap: () {
          Get.to(
            AlertDetailPage(alertId: alert.id, alertType: alert.alertType),
          );
        },
        child: Container(
          width: (MediaQuery.of(context).size.width - 44) / 2,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 2,
              color: isDark ? Colors.grey[700]! : AppColors.borderColor,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.3) : Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              homeController.role.value != 'Doctor'
                  ? Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 16,
                          color: isDark ? Colors.white70 : AppColors.textColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            alert.doctorName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),

              if (homeController.role.value != 'Doctor')
                const SizedBox(height: 8),

              Row(
                children: [
                  Icon(
                    Icons.groups_2,
                    size: 16,
                    color: isDark ? Colors.white70 : AppColors.textColor,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      alert.teamName ?? 'no_team'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white70 : AppColors.textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 16,
                    color: isDark ? Colors.white70 : AppColors.textColor,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(alert.serverCreateTime),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white70 : AppColors.textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Icon(
                    Icons.qr_code_sharp,
                    size: 16,
                    color: isDark ? Colors.white70 : AppColors.textColor,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      alert.trackId ?? 'no_trackid'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white70 : AppColors.textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: statusData['color'].withOpacity(isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusData['color'], width: 1),
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

              if (alert.alertStatus == 5 &&
                  homeController.role.value == 'Admin') ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _closeAlert(alert.id),
                        icon: const Icon(Icons.close, size: 16),
                        label: Text(
                          'Close'.tr,
                          style: const TextStyle(fontSize: 11),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          minimumSize: const Size(0, 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else if (alert.alertStatus == 6 &&
                  homeController.role.value == 'Admin') ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _downloadPDF(alert.id),
                        icon: const Icon(
                          Icons.download_for_offline_rounded,
                          size: 22,
                        ),
                        label: Text(
                          'Download',
                          style: const TextStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget searching(
    BuildContext context,
    TextEditingController controller,
    bool isDark,
  ) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.grey[850] : Colors.white,
        border: Border.all(
          color: isDark ? Colors.grey[700]! : AppColors.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        onChanged: (value) {
          alertController.onSearchChanged(value);
        },
        decoration: InputDecoration(
          hintText: 'search_by_doctor_team'.tr,
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey,
            fontSize: 14,
          ),
          suffixIcon: Obx(() {
            if (alertController.searchQuery.value.isNotEmpty) {
              return IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 20,
                  color: isDark ? Colors.grey[400] : Colors.grey,
                ),
                onPressed: () {
                  controller.clear();
                  alertController.onSearchChanged("");
                },
              );
            }
            return Icon(
              Icons.search,
              color: isDark ? Colors.grey[400] : Colors.grey,
            );
          }),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: isDark ? Colors.grey[850] : Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget buildExpandableFiltersContainer(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
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
                  color: AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.1),
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
                    ? buildFiltersContent(isDark)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFiltersContent(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: DropdownFilter(
                    hint: 'filter_by_status'.tr,
                    selectedValue: alertController.selectedStatus.value,
                    items: alertController.statusOptions,
                    onChanged: (value) =>
                        alertController.onStatusChanged(value),
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
            ),
          ),
          const SizedBox(height: 16),
          if (alertController.userRole.value == 'Admin') ...[
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark
                              ? Colors.grey[600]!
                              : AppColors.borderColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isDark ? Colors.grey[800] : Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: alertController.selectedUserId.value,
                          hint: Text(
                            'filter_by_user'.tr,
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey,
                            ),
                          ),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          dropdownColor: isDark
                              ? Colors.grey[800]
                              : Colors.white,
                          onChanged: (value) =>
                              alertController.onUserIdChanged(value),
                          items: [
                            DropdownMenuItem<String>(
                              value: null,
                              child: Text('all_users'.tr),
                            ),
                            ...homeController.users
                                .map(
                                  (user) => DropdownMenuItem<String>(
                                    value: user.id,
                                    child: Text(user.fullName),
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark
                              ? Colors.grey[600]!
                              : AppColors.borderColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isDark ? Colors.grey[800] : Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: alertController.selectedTeamId.value,
                          hint: Text(
                            'filter_by_team'.tr,
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey,
                            ),
                          ),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          dropdownColor: isDark
                              ? Colors.grey[800]
                              : Colors.white,
                          onChanged: (value) =>
                              alertController.onTeamIdChanged(value),
                          items: [
                            DropdownMenuItem<String>(
                              value: null,
                              child: Text('all_teams'.tr),
                            ),
                            ...homeController.teams
                                .map(
                                  (team) => DropdownMenuItem<String>(
                                    value: team.id,
                                    child: Text(team.name),
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          Text(
            'date_range_filter'.tr,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
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
                      border: Border.all(
                        color: isDark
                            ? Colors.grey[600]!
                            : AppColors.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: isDark ? Colors.grey[800] : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: isDark ? Colors.grey[400] : Colors.grey,
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
                                    ? (isDark ? Colors.white : Colors.black)
                                    : (isDark ? Colors.grey[400] : Colors.grey),
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
                            child: Icon(
                              Icons.clear,
                              size: 16,
                              color: isDark ? Colors.grey[400] : Colors.grey,
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
                      border: Border.all(
                        color: isDark
                            ? Colors.grey[600]!
                            : AppColors.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: isDark ? Colors.grey[800] : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: isDark ? Colors.grey[400] : Colors.grey,
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
                                    ? (isDark ? Colors.white : Colors.black)
                                    : (isDark ? Colors.grey[400] : Colors.grey),
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
                            child: Icon(
                              Icons.clear,
                              size: 16,
                              color: isDark ? Colors.grey[400] : Colors.grey,
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
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
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
                    border: Border.all(
                      color: isDark ? Colors.grey[600]! : AppColors.borderColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: isDark ? Colors.grey[800] : Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Obx(
                      () => DropdownButton<String>(
                        isExpanded: true,
                        value: alertController.sortBy.value,
                        hint: Text(
                          'sort_by'.tr,
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey,
                          ),
                        ),
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        dropdownColor: isDark ? Colors.grey[800] : Colors.white,
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
                      border: Border.all(
                        color: isDark
                            ? Colors.grey[600]!
                            : AppColors.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: alertController.sortDescending.value
                          ? AppColors.primaryColor.withOpacity(
                              isDark ? 0.2 : 0.1,
                            )
                          : (isDark ? Colors.grey[800] : Colors.white),
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
                              : (isDark ? Colors.grey[400] : Colors.grey),
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
                                : (isDark ? Colors.grey[400] : Colors.grey),
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
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    search.clear();
                    alertController.clearFilters();
                  },
                  icon: const Icon(Icons.clear_all, size: 18),
                  label: Text('clear_all_filters'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.grey[700]
                        : Colors.grey.withOpacity(0.2),
                    foregroundColor: isDark ? Colors.white70 : Colors.grey[700],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? ColorScheme.dark(
                    primary: AppColors.primaryColor,
                    surface: Colors.grey[800]!,
                  )
                : ColorScheme.light(primary: AppColors.primaryColor),
          ),
          child: child!,
        );
      },
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

  // قسمت profileHeader را این شکل تغییر دهید:

  Widget profileHeader(bool isDark) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'reports'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Obx(
              () => Text(
                '${alertController.alerts.length} ${'reports_available'.tr}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(54),
            color: isDark ? Colors.grey[800] : AppColors.backgroundColor,
            border: Border.all(
              color: isDark ? Colors.grey[600]! : AppColors.borderColor,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Obx(() {
                  final unreadCount =
                      controller.currentLoginUser.value?.unReadMessagesCount ??
                      0;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(NotificationPage());
                        },
                        child: Icon(
                          Icons.notifications_none_rounded,
                          color: isDark ? Colors.white70 : Colors.black,
                        ),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDark
                                    ? Colors.grey[800]!
                                    : AppColors.backgroundColor,
                                width: 1,
                              ),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              unreadCount > 99 ? '99+' : unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
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
