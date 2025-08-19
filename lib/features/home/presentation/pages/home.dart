import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/features/add_report/presentation/pages/add_report.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/home/presentation/pages/widgets/navigationbar.dart';
import 'package:test3/features/home/presentation/pages/widgets/reports.dart';
import 'package:test3/features/profile/presentation/pages/profile.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController homeController = Get.find<HomeController>();

  final pages = [
    const ProfilePage(),
     ReportsPage(),
     AddReportPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: pages[homeController.selectedIndex.value],
          bottomNavigationBar: CrystalBottomNav(),
        ));
  }
}
