import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';


class CrystalBottomNav extends StatelessWidget {
  CrystalBottomNav({super.key});

  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => CrystalNavigationBar(
          currentIndex: homeController.selectedIndex.value,
          curve: Curves.easeIn,
          enableFloatingNavBar: true,
          paddingR: const EdgeInsets.symmetric(horizontal: 24),
          borderRadius: 54,
          onTap: homeController.changePage,
          backgroundColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.backgroundColor,
        
          indicatorColor:AppColors.backgroundColor,
          items: [
            CrystalNavigationBarItem(
              icon: Icons.person,
              selectedColor: AppColors.backgroundColor,
            ),
            CrystalNavigationBarItem(
              icon: Icons.list_alt_rounded,
            selectedColor: AppColors.backgroundColor,
            ),
            CrystalNavigationBarItem(
              icon: Icons.add_circle_outline,
               selectedColor: AppColors.backgroundColor,
            ),
          ],
        ));
  }
}
