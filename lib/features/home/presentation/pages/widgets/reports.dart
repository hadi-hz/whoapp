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

  bool _isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 768;
  }

  bool _isLargeTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    if (width >= 600) return 3;
    return 2;
  }

  double _getCardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = _isTablet(context) ? 24.0 : 16.0;
    final spacing = 12.0;
    final crossAxisCount = _getCrossAxisCount(context);
    return (width - (padding * 2) - (spacing * (crossAxisCount - 1))) /
        crossAxisCount;
  }

  EdgeInsets _getScreenPadding(BuildContext context) {
    if (_isLargeTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    } else if (_isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 20);
    }
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = _isTablet(context);
    final screenPadding = _getScreenPadding(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: false,
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
          padding: screenPadding,
          child: RefreshIndicator(
            onRefresh: () async {
              alertController.refreshAlerts();
            },
            color: AppColors.primaryColor,
            backgroundColor: isDark ? Colors.grey[800] : Colors.white,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: isTablet ? 32 : 24),
                  profileHeader(isDark, isTablet),
                  SizedBox(height: isTablet ? 24 : 16),
                  searching(context, search, isDark, isTablet),
                  SizedBox(height: isTablet ? 24 : 16),
                  buildExpandableFiltersContainer(isDark, isTablet),
                  SizedBox(height: isTablet ? 24 : 16),

                  // Content section with pagination
                  Obx(() {
                    if (alertController.isLoading.value) {
                      return SizedBox(
                        height: isTablet
                            ? context.height * 0.4
                            : context.height * 0.3,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      );
                    }

                    if (alertController.hasError.value) {
                      return SizedBox(
                        height: isTablet
                            ? context.height * 0.4
                            : context.height * 0.3,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: isTablet ? 80 : 64,
                                color: isDark ? Colors.red[300] : Colors.red,
                              ),
                              SizedBox(height: isTablet ? 20 : 16),
                              Text(
                                alertController.errorMessage.value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isTablet ? 18 : 16,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black87,
                                ),
                              ),
                              SizedBox(height: isTablet ? 20 : 16),
                              ElevatedButton(
                                onPressed: () =>
                                    alertController.refreshAlerts(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 24 : 16,
                                    vertical: isTablet ? 16 : 12,
                                  ),
                                ),
                                child: Text(
                                  'retry'.tr,
                                  style: TextStyle(
                                    fontSize: isTablet ? 16 : 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (alertController.alerts.isEmpty) {
                      return SizedBox(
                        height: isTablet
                            ? context.height * 0.4
                            : context.height * 0.3,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: isTablet ? 80 : 64,
                                color: isDark ? Colors.grey[400] : Colors.grey,
                              ),
                              SizedBox(height: isTablet ? 20 : 16),
                              Text(
                                'no_reports_found'.tr,
                                style: TextStyle(
                                  fontSize: isTablet ? 18 : 16,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black87,
                                ),
                              ),
                              if (alertController
                                  .searchQuery
                                  .value
                                  .isNotEmpty) ...[
                                SizedBox(height: isTablet ? 12 : 8),
                                Text(
                                  '${'no_results_for'.tr} "${alertController.searchQuery.value}"',
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey,
                                    fontSize: isTablet ? 14 : 12,
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
                                SizedBox(height: isTablet ? 12 : 8),
                                TextButton(
                                  onPressed: () {
                                    search.clear();
                                    alertController.clearFilters();
                                  },
                                  child: Text(
                                    'clear_filters'.tr,
                                    style: TextStyle(
                                      fontSize: isTablet ? 16 : 14,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        // Grid/List content
                        _buildAlertsGrid(isDark, isTablet),
                        ConstantSpace.mediumVerticalSpacer,
                        // Pagination
                        // _buildPagination(isDark, isTablet),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertsGrid(bool isDark, bool isTablet) {
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
                : homeController.role.value == 'ServiceProvider'
                ? Colors.red
                : Colors.orange,
          };
        case 3:
          return {
            'name': 'visited_by_team_member'.tr,
            'color': homeController.role.value == 'Admin'
                ? const Color.fromARGB(255, 208, 189, 13)
                : homeController.role.value == 'ServiceProvider'
                ? const Color.fromARGB(255, 208, 189, 13)
                : Colors.purple,
          };
        case 4:
          return {
            'name': 'team_start_processing'.tr,
            'color': homeController.role.value == 'Admin'
                ? const Color.fromARGB(255, 208, 189, 13)
                : homeController.role.value == 'ServiceProvider'
                ? Colors.orange
                : Colors.teal,
          };
        case 5:
          return {
            'name': 'team_finish_processing'.tr,
            'color': homeController.role.value == 'Admin'
                ? Colors.orange
                : homeController.role.value == 'ServiceProvider'
                ? const Color.fromARGB(255, 208, 189, 13)
                : const Color.fromARGB(255, 208, 189, 13),
          };
        case 6:
          return {
            'name': 'admin_close'.tr,
            'color': homeController.role.value == 'Admin'
                ? Colors.green
                : homeController.role.value == 'ServiceProvider'
                ? Colors.green
                : Colors.red,
          };
        default:
          return {'name': 'Unknown', 'color': Colors.black};
      }
    }

    return isTablet
        ? GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(context),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: _isLargeTablet(context) ? 1.2 : 1.0,
            ),
            itemCount: alertController.alerts.length,
            itemBuilder: (context, index) {
              final alert = alertController.alerts[index];
              final statusData = getStatusData(alert.alertStatus);
              return _buildAlertCard(alert, statusData, isDark, isTablet);
            },
          )
        : Wrap(
            spacing: 12,
            runSpacing: 12,
            children: alertController.alerts.map((alert) {
              final statusData = getStatusData(alert.alertStatus);
              return _buildAlertCard(alert, statusData, isDark, isTablet);
            }).toList(),
          );
  }

  // Widget _buildPagination(bool isDark, bool isTablet) {
  //   return Obx(() {
  //     final currentPage = alertController.currentPage.value;
  //     final totalItems = alertController.alerts.length;
  //     final hasNextPage = alertController.hasNextPage.value;
  //     final hasPreviousPage = currentPage > 1;

  //     if (totalItems == 0) return SizedBox.shrink();

  //     return Padding(
  //       padding: const EdgeInsetsDirectional.only(bottom: 120),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [

  //           Container(
  //             padding: EdgeInsets.symmetric(
  //               horizontal: isTablet ? 16 : 12,
  //               vertical: isTablet ? 12 : 10,
  //             ),
  //             decoration: BoxDecoration(
  //               color: isDark
  //                   ? Colors.grey[800]?.withOpacity(0.3)
  //                   : Colors.grey[50]?.withOpacity(0.5),
  //               borderRadius: BorderRadius.circular(isTablet ? 16 : 14),
  //             ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 // Previous button
  //                 _buildNavButton(
  //                   icon: Icons.chevron_left_rounded,
  //                   label: 'previous'.tr,
  //                   onPressed: hasPreviousPage
  //                       ? () => alertController.previousPage()
  //                       : null,
  //                   isDark: isDark,
  //                   isTablet: isTablet,
  //                   isPrimary: false,
  //                 ),

  //                 // Current page indicator
  //                 Container(
  //                   constraints: BoxConstraints(minWidth: isTablet ? 80 : 70),
  //                   padding: EdgeInsets.symmetric(
  //                     horizontal: isTablet ? 20 : 16,
  //                     vertical: isTablet ? 12 : 10,
  //                   ),
  //                   decoration: BoxDecoration(
  //                     gradient: LinearGradient(
  //                       colors: [
  //                         AppColors.primaryColor,
  //                         AppColors.primaryColor.withOpacity(0.8),
  //                       ],
  //                       begin: Alignment.topLeft,
  //                       end: Alignment.bottomRight,
  //                     ),
  //                     borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
  //                     boxShadow: [
  //                       BoxShadow(
  //                         color: AppColors.primaryColor.withOpacity(0.3),
  //                         blurRadius: 8,
  //                         spreadRadius: 0,
  //                         offset: const Offset(0, 2),
  //                       ),
  //                     ],
  //                   ),
  //                   child: Text(
  //                     currentPage.toString(),
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                       fontSize: isTablet ? 16 : 14,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ),

  //                 // Next button
  //                 _buildNavButton(
  //                   icon: Icons.chevron_right_rounded,
  //                   label: 'next'.tr,
  //                   onPressed: hasNextPage
  //                       ? () => alertController.nextPage()
  //                       : null,
  //                   isDark: isDark,
  //                   isTablet: isTablet,
  //                   isPrimary: true,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   });
  // }

  // Widget _buildNavButton({
  //   required IconData icon,
  //   required String label,
  //   required VoidCallback? onPressed,
  //   required bool isDark,
  //   required bool isTablet,
  //   required bool isPrimary,
  // }) {
  //   final isEnabled = onPressed != null;

  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 200),
  //     child: Material(
  //       color: Colors.transparent,
  //       borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
  //       child: InkWell(
  //         onTap: onPressed,
  //         borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
  //         child: Container(
  //           padding: EdgeInsets.symmetric(
  //             horizontal: isTablet ? 16 : 14,
  //             vertical: isTablet ? 10 : 8,
  //           ),
  //           decoration: BoxDecoration(
  //             gradient: isEnabled
  //                 ? (isPrimary
  //                       ? LinearGradient(
  //                           colors: [
  //                             AppColors.primaryColor.withOpacity(0.1),
  //                             AppColors.primaryColor.withOpacity(0.05),
  //                           ],
  //                         )
  //                       : LinearGradient(
  //                           colors: [
  //                             Colors.grey.withOpacity(0.1),
  //                             Colors.grey.withOpacity(0.05),
  //                           ],
  //                         ))
  //                 : null,
  //             borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
  //             border: Border.all(
  //               color: isEnabled
  //                   ? (isPrimary
  //                         ? AppColors.primaryColor.withOpacity(0.3)
  //                         : (isDark ? Colors.grey[600]! : Colors.grey[300]!))
  //                   : (isDark ? Colors.grey[700]! : Colors.grey[200]!),
  //               width: 1,
  //             ),
  //           ),
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Icon(
  //                 icon,
  //                 size: isTablet ? 18 : 16,
  //                 color: isEnabled
  //                     ? (isPrimary
  //                           ? AppColors.primaryColor
  //                           : (isDark ? Colors.white70 : Colors.black87))
  //                     : (isDark ? Colors.grey[600] : Colors.grey[400]),
  //               ),
  //               if (isTablet) ...[
  //                 SizedBox(width: 6),
  //                 Text(
  //                   label,
  //                   style: TextStyle(
  //                     fontSize: 13,
  //                     fontWeight: FontWeight.w500,
  //                     color: isEnabled
  //                         ? (isPrimary
  //                               ? AppColors.primaryColor
  //                               : (isDark ? Colors.white70 : Colors.black87))
  //                         : (isDark ? Colors.grey[600] : Colors.grey[400]),
  //                   ),
  //                 ),
  //               ],
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildAlertCard(alert, statusData, bool isDark, bool isTablet) {
    final cardWidth = isTablet ? null : _getCardWidth(context);

    return IntrinsicHeight(
      child: GestureDetector(
        onTap: () {
          Get.to(
            AlertDetailPage(alertId: alert.id, alertType: alert.alertType),
          );
        },
        child: Container(
          width: cardWidth,
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            border: Border.all(
              width: isTablet ? 2 : 2,
              color: isDark ? Colors.grey[700]! : AppColors.borderColor,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.3) : Colors.black12,
                blurRadius: isTablet ? 8 : 6,
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
                          size: isTablet ? 20 : 16,
                          color: isDark ? Colors.white70 : AppColors.textColor,
                        ),
                        SizedBox(width: isTablet ? 6 : 4),
                        Expanded(
                          child: Text(
                            alert.doctorName,
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
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
                SizedBox(height: isTablet ? 12 : 8),

              Row(
                children: [
                  Icon(
                    Icons.groups_2,
                    size: isTablet ? 20 : 16,
                    color: isDark ? Colors.white70 : AppColors.textColor,
                  ),
                  SizedBox(width: isTablet ? 6 : 4),
                  Expanded(
                    child: Text(
                      alert.teamName ?? 'no_team'.tr,
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white70 : AppColors.textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 12 : 8),

              Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: isTablet ? 20 : 16,
                    color: isDark ? Colors.white70 : AppColors.textColor,
                  ),
                  SizedBox(width: isTablet ? 6 : 4),
                  Expanded(
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(alert.serverCreateTime),
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: isDark ? Colors.white70 : AppColors.textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 12 : 8),

              Row(
                children: [
                  Icon(
                    Icons.qr_code_sharp,
                    size: isTablet ? 20 : 16,
                    color: isDark ? Colors.white70 : AppColors.textColor,
                  ),
                  SizedBox(width: isTablet ? 6 : 4),
                  Expanded(
                    child: Text(
                      alert.trackId ?? 'no_trackid'.tr,
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white70 : AppColors.textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 16 : 12),

              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 12 : 8,
                  vertical: isTablet ? 8 : 6,
                ),
                decoration: BoxDecoration(
                  color: statusData['color'].withOpacity(isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                  border: Border.all(color: statusData['color'], width: 1),
                ),
                child: Text(
                  statusData['name'],
                  style: TextStyle(
                    fontSize: isTablet ? 13 : 11,
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
  }

  Widget searching(
    BuildContext context,
    TextEditingController controller,
    bool isDark,
    bool isTablet,
  ) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
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
            blurRadius: isTablet ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: isTablet ? 16 : 14,
        ),
        onChanged: (value) {
          alertController.onSearchChanged(value);
        },
        decoration: InputDecoration(
          hintText: 'search_by_doctor_team'.tr,
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey,
            fontSize: isTablet ? 16 : 14,
          ),
          suffixIcon: Obx(() {
            if (alertController.searchQuery.value.isNotEmpty) {
              return IconButton(
                icon: Icon(
                  Icons.clear,
                  size: isTablet ? 24 : 20,
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
              size: isTablet ? 24 : 20,
              color: isDark ? Colors.grey[400] : Colors.grey,
            );
          }),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: isDark ? Colors.grey[850] : Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: isTablet ? 20 : 16,
            vertical: isTablet ? 16 : 12,
          ),
        ),
      ),
    );
  }

  Widget buildExpandableFiltersContainer(bool isDark, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
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
        children: [
          GestureDetector(
            onTap: () {
              homeController.toggleFiltersExpansion();
            },
            child: Obx(
              () => Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 20 : 16,
                  vertical: isTablet ? 16 : 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.1),
                  borderRadius: homeController.isFiltersExpanded.value
                      ? BorderRadius.vertical(
                          top: Radius.circular(isTablet ? 20 : 16),
                        )
                      : BorderRadius.circular(isTablet ? 20 : 16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      color: AppColors.primaryColor,
                      size: isTablet ? 24 : 20,
                    ),
                    SizedBox(width: isTablet ? 12 : 8),
                    Text(
                      'filters'.tr,
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
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
                              margin: EdgeInsets.only(right: isTablet ? 12 : 8),
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 10 : 8,
                                vertical: isTablet ? 6 : 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(
                                  isTablet ? 16 : 12,
                                ),
                              ),
                              child: Text(
                                '$activeFilters',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isTablet ? 14 : 12,
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
                        size: isTablet ? 24 : 20,
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
                    ? buildFiltersContent(isDark, isTablet)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFiltersContent(bool isDark, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(isTablet ? 20 : 16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status and Type filters in one row
          Row(
            children: [
              Expanded(
                child: DropdownFilter(
                  hint: 'filter_by_status'.tr,
                  selectedValue: alertController.selectedStatus.value,
                  items: alertController.statusOptions,
                  onChanged: (value) => alertController.onStatusChanged(value),
                ),
              ),
              SizedBox(width: isTablet ? 16 : 12),
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
          SizedBox(height: isTablet ? 20 : 16),

          // Admin-only User and Team filters
          if (alertController.userRole.value == 'Admin') ...[
            Row(
              children: [
                Expanded(child: _buildUserDropdown(isDark, isTablet)),
                SizedBox(width: isTablet ? 16 : 12),
                Expanded(child: _buildTeamDropdown(isDark, isTablet)),
              ],
            ),
            SizedBox(height: isTablet ? 20 : 16),
          ],

          // Date range section
          Text(
            'date_range_filter'.tr,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Row(
            children: [
              Expanded(
                child: _buildDatePicker(context, isDark, isTablet, true),
              ),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(
                child: _buildDatePicker(context, isDark, isTablet, false),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 20 : 16),

          // Sort options section
          Text(
            'sort_options'.tr,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Row(
            children: [
              Expanded(child: _buildSortDropdown(isDark, isTablet)),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(child: _buildSortDirectionButton(isDark, isTablet)),
            ],
          ),
          SizedBox(height: isTablet ? 24 : 20),

          // Action buttons in one row
          Row(
            children: [
              Expanded(child: _buildApplyButton(isTablet)),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(child: _buildClearButton(isDark, isTablet)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserDropdown(bool isDark, bool isTablet) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 16 : 12,
          vertical: isTablet ? 6 : 4,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? Colors.grey[600]! : AppColors.borderColor,
          ),
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
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
                fontSize: isTablet ? 16 : 14,
              ),
            ),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: isTablet ? 16 : 14,
            ),
            dropdownColor: isDark ? Colors.grey[800] : Colors.white,
            onChanged: (value) => alertController.onUserIdChanged(value),
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
    );
  }

  Widget _buildTeamDropdown(bool isDark, bool isTablet) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 16 : 12,
          vertical: isTablet ? 6 : 4,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? Colors.grey[600]! : AppColors.borderColor,
          ),
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
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
                fontSize: isTablet ? 16 : 14,
              ),
            ),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: isTablet ? 16 : 14,
            ),
            dropdownColor: isDark ? Colors.grey[800] : Colors.white,
            onChanged: (value) => alertController.onTeamIdChanged(value),
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
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    bool isDark,
    bool isTablet,
    bool isFromDate,
  ) {
    return GestureDetector(
      onTap: () => _selectDate(context, isFromDate: isFromDate),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 16 : 12,
          vertical: isTablet ? 16 : 12,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? Colors.grey[600]! : AppColors.borderColor,
          ),
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          color: isDark ? Colors.grey[800] : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: isTablet ? 20 : 16,
              color: isDark ? Colors.grey[400] : Colors.grey,
            ),
            SizedBox(width: isTablet ? 12 : 8),
            Expanded(
              child: Obx(
                () => Text(
                  isFromDate
                      ? (alertController.dateFrom.value != null
                            ? DateFormat(
                                'yyyy-MM-dd',
                              ).format(alertController.dateFrom.value!)
                            : 'from_date'.tr)
                      : (alertController.dateTo.value != null
                            ? DateFormat(
                                'yyyy-MM-dd',
                              ).format(alertController.dateTo.value!)
                            : 'to_date'.tr),
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color:
                        (isFromDate
                                ? alertController.dateFrom.value
                                : alertController.dateTo.value) !=
                            null
                        ? (isDark ? Colors.white : Colors.black)
                        : (isDark ? Colors.grey[400] : Colors.grey),
                  ),
                ),
              ),
            ),
            if ((isFromDate
                    ? alertController.dateFrom.value
                    : alertController.dateTo.value) !=
                null)
              GestureDetector(
                onTap: () => alertController.onDateRangeChanged(
                  isFromDate ? null : alertController.dateFrom.value,
                  isFromDate ? alertController.dateTo.value : null,
                ),
                child: Icon(
                  Icons.clear,
                  size: isTablet ? 20 : 16,
                  color: isDark ? Colors.grey[400] : Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortDropdown(bool isDark, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 12,
        vertical: isTablet ? 6 : 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? Colors.grey[600]! : AppColors.borderColor,
        ),
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
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
                fontSize: isTablet ? 16 : 14,
              ),
            ),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: isTablet ? 16 : 14,
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
              DropdownMenuItem(value: 'alertStatus', child: Text('status'.tr)),
              DropdownMenuItem(value: 'alertType', child: Text('type'.tr)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortDirectionButton(bool isDark, bool isTablet) {
    return Obx(
      () => GestureDetector(
        onTap: () => alertController.onSortChanged(
          alertController.sortBy.value,
          !alertController.sortDescending.value,
        ),
        child: Container(
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? Colors.grey[600]! : AppColors.borderColor,
            ),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            color: alertController.sortDescending.value
                ? AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.1)
                : (isDark ? Colors.grey[800] : Colors.white),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                alertController.sortDescending.value
                    ? Icons.arrow_downward
                    : Icons.arrow_upward,
                size: isTablet ? 20 : 16,
                color: alertController.sortDescending.value
                    ? AppColors.primaryColor
                    : (isDark ? Colors.grey[400] : Colors.grey),
              ),
              SizedBox(width: isTablet ? 6 : 4),
              Text(
                alertController.sortDescending.value ? 'desc'.tr : 'asc'.tr,
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  color: alertController.sortDescending.value
                      ? AppColors.primaryColor
                      : (isDark ? Colors.grey[400] : Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApplyButton(bool isTablet) {
    return ElevatedButton.icon(
      onPressed: () => alertController.refreshAlerts(),
      icon: Icon(Icons.refresh, size: isTablet ? 20 : 18),
      label: Text(
        'apply_filters'.tr,
        style: TextStyle(fontSize: isTablet ? 16 : 14),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
        ),
      ),
    );
  }

  Widget _buildClearButton(bool isDark, bool isTablet) {
    return ElevatedButton.icon(
      onPressed: () {
        search.clear();
        alertController.clearFilters();
      },
      icon: Icon(Icons.clear_all, size: isTablet ? 20 : 18),
      label: Text(
        'clear_all_filters'.tr,
        style: TextStyle(fontSize: isTablet ? 16 : 14),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark
            ? Colors.grey[700]
            : Colors.grey.withOpacity(0.2),
        foregroundColor: isDark ? Colors.white70 : Colors.grey[700],
        elevation: 0,
        padding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
        ),
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

  Widget profileHeader(bool isDark, bool isTablet) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'reports'.tr,
              style: TextStyle(
                fontSize: isTablet ? 24 : 18,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: isTablet ? 6 : 4),
            Obx(
              () => Text(
                '${alertController.alerts.length} ${'reports_available'.tr}',
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          height: isTablet ? 70 : 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isTablet ? 70 : 54),
            color: isDark ? Colors.grey[800] : AppColors.backgroundColor,
            border: Border.all(
              color: isDark ? Colors.grey[600]! : AppColors.borderColor,
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 12.0 : 8.0),
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
                          homeController.isNotificationSelected.value = true;
                          homeController.isProfileSelected.value = false;

                          Future.delayed(const Duration(milliseconds: 200), () {
                            Get.to(
                              NotificationPage(),
                              transition: Transition.downToUp,
                              duration: const Duration(milliseconds: 400),
                            )?.then((_) {
                              homeController.isNotificationSelected.value =
                                  false;
                              homeController.isProfileSelected.value = true;
                            });
                          });
                        },
                        child: Obx(
                          () => AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            padding: EdgeInsets.all(isTablet ? 12 : 8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    homeController.isNotificationSelected.value
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                                width: 2,
                              ),
                              color: homeController.isNotificationSelected.value
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                            ),
                            child: Icon(
                              Icons.notifications_none_rounded,
                              size: isTablet ? 24 : 20,
                              color: homeController.isNotificationSelected.value
                                  ? AppColors.background
                                  : (isDark ? Colors.white70 : Colors.black),
                            ),
                          ),
                        ),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: EdgeInsets.all(isTablet ? 3 : 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(
                                isTablet ? 10 : 8,
                              ),
                              border: Border.all(
                                color: isDark
                                    ? Colors.grey[800]!
                                    : AppColors.backgroundColor,
                                width: 1,
                              ),
                            ),
                            constraints: BoxConstraints(
                              minWidth: isTablet ? 20 : 16,
                              minHeight: isTablet ? 20 : 16,
                            ),
                            child: Text(
                              unreadCount > 99 ? '99+' : unreadCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isTablet ? 12 : 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
                SizedBox(width: isTablet ? 16 : 12),
                GestureDetector(
                  onTap: () {
                    homeController.isProfileSelected.value = true;
                    homeController.isNotificationSelected.value = false;
                  },
                  child: Obx(
                    () => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: homeController.isProfileSelected.value
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: homeController.isProfileSelected.value
                            ? [
                                BoxShadow(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]
                            : [],
                      ),
                      child: CircleAvatar(
                        backgroundColor: homeController.isProfileSelected.value
                            ? AppColors.primaryColor.withOpacity(0.9)
                            : AppColors.primaryColor,
                        radius: isTablet ? 30 : 24,
                        child: Icon(
                          Icons.person,
                          color: AppColors.backgroundColor,
                          size: homeController.isProfileSelected.value
                              ? (isTablet ? 32 : 26)
                              : (isTablet ? 30 : 24),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
