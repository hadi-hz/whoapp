import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/home/domain/entities/get_filter_alert.dart';
import 'package:test3/features/home/presentation/controller/get_alert_controller.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/home/presentation/pages/widgets/get_teams_by_member_id.dart';
import 'package:test3/features/home/presentation/pages/widgets/navifationbar_admin.dart';
import 'package:test3/features/home/presentation/pages/widgets/navigationbar.dart';
import 'package:test3/features/home/presentation/pages/widgets/navigationbar_service_provider.dart';
import 'package:test3/features/home/presentation/pages/widgets/reports.dart';
import 'package:test3/features/home/presentation/pages/widgets/teams_screen.dart';
import 'package:test3/features/home/presentation/pages/widgets/users_screen.dart';
import 'package:test3/features/profile/presentation/pages/profile.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeController = Get.find<HomeController>();
  final AlertListController alertController = Get.find<AlertListController>();
  List<Widget> pages = [];
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final String? savedUserId = prefs.getString('userId');
      final String? savedRole = prefs.getString('role');

      homeController.role.value = savedRole ?? '';

      setState(() {
        pages = homeController.role.value == 'Admin'
            ? [const ProfilePage(), ReportsPage(), UsersScreen(), TeamsScreen()]
            : homeController.role.value == 'ServiceProvider'
            ? [const ProfilePage(), ReportsPage(), UserTeamsScreen()]
            : [const ProfilePage(), ReportsPage()];
        isInitialized = true;
      });

      
      await _fetchAlerts(savedUserId, savedRole);
    });
  }

  Future<void> _fetchAlerts(String? userId, String? role) async {
  
    final filter = AlertFilterEntity(
      userId: role != 'Admin' ? userId : null,
      sortDescending: true,
      page: 1,
      pageSize: 150,
    );

    
    alertController.selectedUserId.value = filter.userId;
    alertController.sortDescending.value = filter.sortDescending ?? true;
    alertController.currentPage.value = filter.page;
    alertController.pageSize.value = filter.pageSize;


    await alertController.loadAlerts();
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized || pages.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Obx(() {
      int currentIndex = homeController.selectedIndex.value;
      String userRole = homeController.role.value;

      if (currentIndex >= pages.length) {
        currentIndex = 0;
        homeController.selectedIndex.value = 0;
      }

      return Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: userRole == 'Admin'
            ? AnimatedBottomNavAdmin()
            : userRole == 'ServiceProvider'
            ? AnimatedBottomNavServiceProvider()
            : AnimatedBottomNavDoctor(),
      );
    });
  }
}