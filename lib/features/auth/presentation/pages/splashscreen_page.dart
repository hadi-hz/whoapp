import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test3/features/add_report/data/datasource/alert_remote_datasource.dart';
import 'package:test3/features/add_report/data/repositories/alert_repository_impl.dart';
import 'package:test3/features/add_report/presentation/controller/add_report_controller.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/auth/presentation/pages/login_page.dart';
import 'package:test3/features/get_alert_by_id/presentation/pages/get_alert_detail.dart';
import 'package:test3/features/home/presentation/controller/home_controller.dart';
import 'package:test3/features/home/presentation/pages/home.dart';
import 'package:test3/features/home/presentation/pages/widgets/user_detail.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final AddReportController controller = Get.find<AddReportController>();
  final AuthController authController = Get.find<AuthController>();
  final HomeController homeController = Get.find<HomeController>();


   bool _navigationHandled = false; // اضافه کردن flag
 
    @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _initializeApp();
    });
  }
 Future<void> _initializeApp() async {
    try {
      // اول چک کن notification navigation داری یا نه
      final prefs = await SharedPreferences.getInstance();
      final hasNotificationNav = prefs.getBool('notification_navigation') ?? false;
      
      if (hasNotificationNav) {
        // اگه notification navigation داری، مستقیم بره اونجا
        final route = prefs.getString('notification_route') ?? '';
        final parts = route.split(',');
        
        // Clear flag ها
        await prefs.remove('notification_navigation');
        await prefs.remove('notification_route');
        
        _navigationHandled = true;
        await _handleNotificationNavigation(parts);
        return;
      }

      // اگه notification نداری، normal flow
      await Future.delayed(const Duration(milliseconds: 5000));

      if (_navigationHandled) return; // چک کن قبلاً navigate شده یا نه

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
      if (!_navigationHandled) {
        Get.offAll(() => LoginPage());
      }
    }
  }






  Future<void> _handleNotificationNavigation(List<String> parts) async {
    if (parts.length >= 2) {
      final type = parts[0];
      final alertId = parts[1];
      final userId = parts.length > 2 ? parts[2] : null;

      // Load user data اول
      await authController.loadUserFromPrefs();
      
      if (type == 'create_alert' && alertId.isNotEmpty) {
        Get.offAll(() => AlertDetailPage(alertId: alertId));
      } else if (type == 'register_user' && userId != null) {
        Get.offAll(() => UserDetailScreen(userId: userId));
      } else {
        Get.offAll(() => HomePage());
      }
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
