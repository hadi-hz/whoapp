import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:test3/core/const/const.dart';
import 'package:test3/features/add_report/presentation/controller/add_report_controller.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';

import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/home/presentation/pages/widgets/reports.dart';
import 'package:test3/features/home/presentation/pages/widgets/teams_screen.dart';
import 'package:test3/features/home/presentation/pages/widgets/users_screen.dart';
import 'package:test3/features/profile/presentation/pages/profile.dart';

class AnimatedBottomNavAdmin extends StatelessWidget {
  AnimatedBottomNavAdmin({super.key});

  final HomeController homeController = Get.find<HomeController>();
  final AddReportController controller = Get.find<AddReportController>();
  final authController = Get.find<AuthController>();

  final iconList = <IconData>[
    Icons.person,
    Icons.list_alt_rounded,
    Icons.supervised_user_circle,
    Icons.groups_2,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Obx(() {
        return IndexedStack(
          index: homeController.selectedIndex.value,
          children: [
            ProfilePage(),
            ReportsPage(),
            UsersScreen(),
            TeamsScreen(),
          ],
        );
      }),

      bottomNavigationBar: Obx(
        () => AnimatedBottomNavigationBar(
          height: 70,
          iconSize: 28,
          icons: iconList,
          activeIndex: homeController.selectedIndex.value,
          gapLocation: GapLocation.none,
          notchSmoothness: NotchSmoothness.sharpEdge,
          onTap: homeController.changePage,
          backgroundColor: AppColors.primaryColor,
          activeColor: AppColors.backgroundColor,
          inactiveColor: AppColors.backgroundColor.withOpacity(0.6),
          leftCornerRadius: 12,
          rightCornerRadius: 12,
        ),
      ),
    );
  }
}
