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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cardIsApproved(context),
            buttonCheckIsApproved(context, controller.currentUser.value!.id)
          ],
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

  Widget buttonCheckIsApproved(BuildContext context, String userId) {
    return BoxNeumorphysm(
      borderColor: Colors.white,
      onTap: controller.isLoadingCheckIsApproved.value
          ? () {}
          : () {
              controller.checkUserIsApproved(userId: userId);
            },
      borderRadius: 12,
      borderWidth: 5,
      backgroundColor: AppColors.primaryColor,
      topLeftShadowColor: Colors.white,
      bottomRightShadowColor: const Color.fromARGB(255, 139, 204, 222),
      height: 60,
      width: context.width * 0.82,
      bottomRightOffset: const Offset(4, 4),
      topLeftOffset: const Offset(-4, -4),
      child: Center(
        child: Obx(() {
          return controller.isLoadingCheckIsApproved.value
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: AppColors.background),
                )
              : Text(
                  'check_approved'.tr, 
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.background,
                  ),
                );
        }),
      ),
    );
  }
}