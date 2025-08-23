import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
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

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final savedUserId = prefs.getString('userId') ?? '';
      homeController.fetchAlerts(
        userId: savedUserId,
        sortDescending: true,
        page: 1,
        pageSize: 1000,
      );
    });
    super.initState();
  }

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
            bottom: 24,
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
                buildFiltersRow(),
                ConstantSpace.mediumVerticalSpacer,
                SizedBox(
                  height: context.height * 0.65,
                  child: Obx(() {
                    if (homeController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (homeController.errorMessage.value.isNotEmpty) {
                      return Center(
                        child: Text(homeController.errorMessage.value),
                      );
                    }

                    if (homeController.filteredAlerts.isEmpty) {
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
                            if (homeController
                                .searchQuery
                                .value
                                .isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                '${'no_results_for'.tr} "${homeController.searchQuery.value}"', 
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            if (homeController.selectedStatusFilter.value !=
                                    null ||
                                homeController.selectedTypeFilter.value !=
                                    null ||
                                homeController
                                    .searchQuery
                                    .value
                                    .isNotEmpty) ...[
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  search.clear();
                                  homeController.clearFilters();
                                },
                                child: Text('clear_filters'.tr), 
                              ),
                            ],
                          ],
                        ),
                      );
                    }
                    if (homeController.alerts.isEmpty) {
                      return Center(child: Text('no_reports_found'.tr)); 
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
                          return {'name': 'admin_close'.tr, 'color': Colors.red}; 
                        default:
                          return {'name': 'Unknown', 'color': Colors.black}; 
                      }
                    }

                    return ListView.separated(
                      padding: const EdgeInsetsDirectional.only(
                        end: 16,
                        bottom: 80,
                        top: 16,
                        start: 16,
                      ),
                      itemCount: homeController.filteredAlerts.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final alert = homeController.filteredAlerts[index];
                        final statusData = getStatusData(
                          alert.alertStatus ?? 0,
                        );
                        return Container(
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
                          child: Stack(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 120,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: statusData['color'],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Transform.rotate(
                                        angle: 3 * pi / 2,
                                        child: Text(
                                          statusData['name'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      spacing: 8,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.person, size: 16),
                                            const SizedBox(width: 4),
                                            Text(
                                              alert.doctorName ?? '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.groups_2,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              alert.teamName ?? 'no_team'.tr, 
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_month_rounded,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              alert.serverCreateTime != null
                                                  ? DateFormat(
                                                      'yyyy-MM-dd',
                                                    ).format(
                                                      alert.serverCreateTime!,
                                                    )
                                                  : '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 50),
                                ],
                              ),

                              Positioned(
                                bottom: 0,
                                right: 8,
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                  ),
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.print,
                                    color: AppColors.backgroundColor,
                                    size: 20,
                                  ),
                                  tooltip: 'report_pdf'.tr, 
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
      width: MediaQuery.sizeOf(context).width * 0.82,
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
          homeController.changeSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: 'search_by_doctor_team'.tr, 
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          suffixIcon: Obx(() {
            if (homeController.searchQuery.value.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.clear, size: 20, color: Colors.grey),
                onPressed: () {
                  controller.clear();
                  homeController.changeSearchQuery("");
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

  Widget profileHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'hello'.tr, // 'Hello' -> 'hello'.tr
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            ConstantSpace.smallVerticalSpacer,
            Text(
              '${controller.currentLoginUser.value?.name ?? ''}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
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

  Widget buildFiltersRow() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: DropdownFilter(
                hint: 'filter_by_status'.tr, 
                selectedValue: homeController.selectedStatusFilter.value,
                items: homeController.statusList,
                onChanged: (value) => homeController.changeStatusFilter(value),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: DropdownFilter(
                hint: 'filter_by_type'.tr, 
                selectedValue: homeController.selectedTypeFilter.value,
                items: homeController.alertTypeList,
                onChanged: (value) => homeController.changeTypeFilter(value),
              ),
            ),

            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                search.clear();
                homeController.clearFilters();
              },
              icon: const Icon(Icons.refresh),
              tooltip: 'clear_filters_button'.tr,
              style: IconButton.styleFrom(
                shape: CircleBorder(side: BorderSide(width: 2 , color: AppColors.borderColor)),
                backgroundColor: Colors.grey.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}