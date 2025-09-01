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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.checkUserIsApproved(
            userId: controller.currentUser.value!.id,
          );
        },
        color: AppColors.primaryColor,
        backgroundColor: theme.cardColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [cardIsApproved(context)],
            ),
          ),
        ),
      ),
    );
  }

  Widget cardIsApproved(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BoxNeumorphysm(
      backgroundColor: AppColors.primaryColor,
      width: context.width,
      height: context.height * 0.55,
      borderColor: isDark ? theme.dividerColor : AppColors.textColor,
      topLeftShadowColor: isDark ? theme.highlightColor : Colors.white,
      bottomRightShadowColor: isDark
          ? theme.shadowColor.withOpacity(0.3)
          : const Color.fromARGB(255, 139, 204, 222),
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
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          InnerShadowContainer(
            width: context.width * 0.34,
            height: 40,
            blur: 8,
            offset: const Offset(5, 5),
            shadowColor: isDark
                ? theme.shadowColor.withOpacity(0.5)
                : AppColors.innershadow,
            backgroundColor: isDark ? theme.cardColor : AppColors.background,
            borderRadius: 20,
            child: Lottie.asset('assets/lottie/loading.json'),
          ),
          Obx(() => _buildStatusSection(context)),
        ],
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: controller.isLoadingCheckIsApproved.value
            ? theme.colorScheme.onPrimary.withOpacity(0.1)
            : theme.colorScheme.onPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.onPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          if (controller.isLoadingCheckIsApproved.value) ...[
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'checking_approval_status'.tr,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ] else ...[
            Icon(
              Icons.refresh_rounded,
              color: theme.colorScheme.onPrimary.withOpacity(0.7),
              size: 20,
            ),
            const SizedBox(height: 6),
            Text(
              'pull_down_to_check_status'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onPrimary.withOpacity(0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
