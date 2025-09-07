import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/add_report/data/datasource/alert_remote_datasource.dart';
import 'package:test3/features/add_report/data/repositories/alert_repository_impl.dart';
import 'package:test3/features/add_report/presentation/controller/add_report_controller.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/auth/presentation/pages/login_page.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/home/presentation/pages/home.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final AddReportController controller = Get.find<AddReportController>();
  final AuthController authController = Get.find<AuthController>();
  final HomeController homeController = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _initializeApp();
    });
  }

 Future<void> _initializeApp() async {
  try {
    await Future.delayed(const Duration(milliseconds: 5000));

    final prefs = await SharedPreferences.getInstance();
    final String? savedUserId = prefs.getString('userId');
    final String? savedUserName = prefs.getString('userName');
    final bool? isUserApproved = prefs.getBool('isUserApproved'); 

    controller.getCurrentLocation();

    if (savedUserId != null && 
        savedUserId.isNotEmpty && 
        savedUserName != null && 
        isUserApproved == true) {
      
    
      await authController.loadUserFromPrefs();
      
      Get.offAll(
        () => HomePage(),
        transition: Transition.downToUp,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      Get.offAll(
        () => LoginPage(),
        transition: Transition.downToUp,
        duration: const Duration(milliseconds: 300),
      );
    }
  } catch (e) {
    Get.offAll(() => LoginPage());
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/splashscreen.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.medical_services, size: 80, color: Colors.white),
                    SizedBox(height: 20),
                    Text(
                      'app_name'.tr,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 40),
                    CircularProgressIndicator(color: Colors.white),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
