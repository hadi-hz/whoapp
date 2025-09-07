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

  // Helper method for responsive values
  double _getResponsiveValue({
    required double mobile,
    required double tablet,
    required double desktop,
    required double screenWidth,
  }) {
    if (screenWidth >= 1200) return desktop;
    if (screenWidth >= 600) return tablet;
    return mobile;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive values
    final cardMaxWidth = _getResponsiveValue(
      mobile: screenWidth,
      tablet: 500.0,
      desktop: 600.0,
      screenWidth: screenWidth,
    );

    final horizontalPadding = _getResponsiveValue(
      mobile: 20.0,
      tablet: 40.0,
      desktop: 60.0,
      screenWidth: screenWidth,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.transparent : AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
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
            height: screenHeight - kToolbarHeight,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Center(
              child: Container(
                width: cardMaxWidth,
                child: cardIsApproved(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget cardIsApproved(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive dimensions
    final cardHeight = _getResponsiveValue(
      mobile: screenHeight * 0.55,
      tablet: 500.0,
      desktop: 550.0,
      screenWidth: screenWidth,
    );

    final logoSize = _getResponsiveValue(
      mobile: 130.0,
      tablet: 160.0,
      desktop: 180.0,
      screenWidth: screenWidth,
    );

    final titleFontSize = _getResponsiveValue(
      mobile: 16.0,
      tablet: 20.0,
      desktop: 24.0,
      screenWidth: screenWidth,
    );

    final loadingContainerWidth = _getResponsiveValue(
      mobile: screenWidth * 0.34,
      tablet: 150.0,
      desktop: 180.0,
      screenWidth: screenWidth,
    );

    final loadingContainerHeight = _getResponsiveValue(
      mobile: 40.0,
      tablet: 50.0,
      desktop: 60.0,
      screenWidth: screenWidth,
    );

    final cardPadding = _getResponsiveValue(
      mobile: 20.0,
      tablet: 30.0,
      desktop: 40.0,
      screenWidth: screenWidth,
    );

    return BoxNeumorphysm(
      backgroundColor: AppColors.primaryColor,
      width: double.infinity,
      height: cardHeight,
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
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: logoSize,
              height: logoSize,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth >= 600 ? 20 : 10,
              ),
              child: Text(
                'register_success'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
            InnerShadowContainer(
              width: loadingContainerWidth,
              height: loadingContainerHeight,
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
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    final statusFontSize = _getResponsiveValue(
      mobile: 12.0,
      tablet: 14.0,
      desktop: 16.0,
      screenWidth: screenWidth,
    );

    final iconSize = _getResponsiveValue(
      mobile: 20.0,
      tablet: 24.0,
      desktop: 28.0,
      screenWidth: screenWidth,
    );

    final statusPadding = _getResponsiveValue(
      mobile: 16.0,
      tablet: 20.0,
      desktop: 24.0,
      screenWidth: screenWidth,
    );

    final statusMargin = _getResponsiveValue(
      mobile: 20.0,
      tablet: 30.0,
      desktop: 40.0,
      screenWidth: screenWidth,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: statusPadding,
        vertical: statusPadding,
      ),
      margin: EdgeInsets.symmetric(horizontal: statusMargin),
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
              width: iconSize,
              height: iconSize,
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
                fontSize: statusFontSize,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ] else ...[
            Icon(
              Icons.refresh_rounded,
              color: theme.colorScheme.onPrimary.withOpacity(0.7),
              size: iconSize,
            ),
            const SizedBox(height: 6),
            Text(
              'pull_down_to_check_status'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: statusFontSize,
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