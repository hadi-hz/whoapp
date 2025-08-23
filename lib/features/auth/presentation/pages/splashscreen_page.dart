import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/features/add_report/data/datasource/alert_remote_datasource.dart';
import 'package:test3/features/add_report/data/repositories/alert_repository_impl.dart';
import 'package:test3/features/add_report/presentation/controller/add_report_controller.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/auth/presentation/pages/login_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final AddReportController controller = Get.find<AddReportController>();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      controller.getCurrentLocation();
      Get.off(
        () => LoginPage(),
        transition: Transition.downToUp,
        duration: const Duration(milliseconds: 400),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset('assets/images/splashscreen.png', fit: BoxFit.cover),
      ),
    );
  }
}
