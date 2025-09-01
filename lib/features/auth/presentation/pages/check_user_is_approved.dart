import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/auth/presentation/pages/widgets/box_neumorphysm.dart';
import 'package:test3/features/auth/presentation/pages/widgets/inner_shadow_container.dart';

class ApprovedUserPage extends StatelessWidget {
  ApprovedUserPage({super.key});
  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.checkUserIsApproved(
            userId: controller.currentUser.value!.id,
          );
        },
        color: AppColors.primaryColor,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                cardIsApproved(context),
                const SizedBox(height: 20),
                _buildRefreshHint(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cardIsApproved(BuildContext context) {
    return BoxNeumorphysm(
      backgroundColor: AppColors.primaryColor,
      width: context.width,
      height: context.height * 0.45,
      borderColor: AppColors.textColor,
      topLeftShadowColor: Colors.white,
      bottomRightShadowColor: const Color.fromARGB(255, 139, 204, 222),
      bottomRightOffset: const Offset(4, 4),
      topLeftOffset: const Offset(-4, -4),
      onTap: () {},
      borderRadius: 20,
      borderWidth: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 130,
            height: 130,
            fit: BoxFit.cover,
          ),
          Text(
            'register_success'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.background,
            ),
          ),
          InnerShadowContainer(
            width: context.width * 0.34,
            height: 40,
            blur: 8,
            offset: const Offset(5, 5),
            shadowColor: AppColors.innershadow,
            backgroundColor: AppColors.background,
            borderRadius: 20,
            child: Lottie.asset('assets/lottie/loading.json'),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshHint(BuildContext context) {
    return Obx(() {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: controller.isLoadingCheckIsApproved.value 
              ? AppColors.primaryColor.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: controller.isLoadingCheckIsApproved.value 
                ? AppColors.primaryColor
                : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            if (controller.isLoadingCheckIsApproved.value) ...[
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'checking_approval_status'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
            ] else ...[
              AnimatedContainer(
                duration: const Duration(milliseconds: 1500),
                child: Icon(
                  Icons.refresh,
                  color: Colors.grey[600],
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'pull_down_to_check_status'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'swipe_down_hint'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}