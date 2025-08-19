import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/auth/presentation/pages/widgets/text_filed.dart';
import 'package:test3/features/home/data/model/get_alert_model.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';

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
    // TODO: implement initState
    homeController.fetchAlerts(
      GetAlertRequestModel(
        userId: "e9ba7bb4-f843-46c4-af85-2eac206d2c15",
        status: null,
        type: null,
        registerDateFrom: DateTime.parse("2025-08-10T05:17:27.981Z"),
        registerDateTo: DateTime.parse("2025-08-19T05:17:27.981Z"),
        sortBy: "string",
        sortDescending: true,
        page: 1,
        pageSize: 10,
      ),
    );

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
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstantSpace.largeVerticalSpacer,
              ConstantSpace.largeVerticalSpacer,
              profileHeader(),
              ConstantSpace.mediumVerticalSpacer,
              searching(context, search),
              ConstantSpace.mediumVerticalSpacer,
              SizedBox(
                height: context.height * 0.6,
                child: Obx(() {
                  if (homeController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (homeController.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Text(homeController.errorMessage.value),
                    );
                  }

                  if (homeController.alerts.isEmpty) {
                    return const Center(child: Text('No reports found'));
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: homeController.alerts.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final alert = homeController.alerts[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppColors.innershadow,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Icon(Icons.image_outlined),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    alert.alertDescriptionByDoctor ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Text(
                                  //   alert.date ?? '',
                                  //   style: const TextStyle(
                                  //     fontSize: 14,
                                  //     color: Colors.grey,
                                  //   ),
                                  // ),
                                  // const SizedBox(height: 4),
                                  // Text(
                                  //   alert.serviceName ?? '',
                                  //   style: const TextStyle(fontSize: 14),
                                  // ),
                                ],
                              ),
                            ),
                            IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                              ),
                              onPressed: () {},
                              icon: Icon(
                                Icons.print,
                                color: AppColors.backgroundColor,
                                size: 20,
                              ),
                              tooltip: 'Report PDF',
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
    );
  }

  Widget searching(BuildContext context, controller) {
    return TextFieldInnerShadow(
      borderRadius: 16,
      controller: controller,
      height: 60,
      hintText: "Search",
      suffixIcon: const Icon(Icons.search),
      validator: (p0) {
        return null;
      },
      width: MediaQuery.sizeOf(context).width * 0.82,
    );
  }

  Widget profileHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            ConstantSpace.smallVerticalSpacer,
            Text(
              '${controller.currentLoginUser.value?.name ?? ''}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
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
}
