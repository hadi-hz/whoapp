import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/core/theme/theme_controller.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/auth/presentation/pages/login_page.dart';
import 'package:test3/features/auth/presentation/pages/widgets/box_neumorphysm.dart';
import 'package:test3/features/auth/presentation/pages/widgets/text_filed.dart';
import 'package:test3/shared/change_lang.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final controller = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setStatusBarStyle();
      controller.runAnimations();
    });
  }

  void _setStatusBarStyle() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: isDark ? Colors.grey[900] : AppColors.primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
       resizeToAvoidBottomInset: false,
      backgroundColor: isDark
          ? theme.scaffoldBackgroundColor
          : AppColors.background,
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            Positioned(top: 0, left: 0, right: 0, child: bodyTitles(context)),
            Positioned(
              top: screenHeight < 700
                  ? screenHeight * 0.32
                  : screenHeight * 0.28,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: screenWidth,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      loginInformation(context),
                      ConstantSpace.mediumVerticalSpacer,
                      inputName(context, controller.name),
                      ConstantSpace.smallVerticalSpacer,
                      inputLastName(context, controller.lastName),
                      ConstantSpace.smallVerticalSpacer,
                      inputEmail(context, controller.email),
                      ConstantSpace.smallVerticalSpacer,
                      inputPassword(context, controller.password),
                      ConstantSpace.mediumVerticalSpacer,
                      buttonRegister(context),
                      ConstantSpace.mediumVerticalSpacer,
                      secondSection(context),
                      ConstantSpace.mediumVerticalSpacer,
                      buttonRegisterGoogle(context),
                      ConstantSpace.mediumVerticalSpacer,
                      SignInButton(context),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bodyTitles(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final baseHeight = screenHeight < 1280 ? 250.0 : 600.0;
    final logoSize = screenWidth < 800
        ? 100.0
        : screenWidth < 1024
        ? 180.0
        : screenWidth < 1280
        ? 200.0
        : 300.0;
    final fontSize32 = screenWidth < 400 ? 26.0 : 32.0;
    final fontSize26 = screenWidth < 400 ? 20.0 : 26.0;
    final fontSize16 = screenWidth < 400 ? 14.0 : 16.0;

    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: baseHeight + statusBarHeight,
      color: isDark ? theme.primaryColor : AppColors.primaryColor,
      child: Padding(
        padding: EdgeInsets.only(
          top: statusBarHeight + (screenHeight < 700 ? 8 : 16),
        ),
        child: Column(
          children: [
            if (screenHeight > 916) ConstantSpace.x3LargeVerticalSpacer,
            if (screenHeight < 700) const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => animatedText(
                          controller.showHello.value,
                          _buildHelloTitle(context, fontSize32),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(
                        () => animatedText(
                          controller.showWelcome.value,
                          _buildWelcomeTitle(context, fontSize26),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(
                        () => animatedText(
                          controller.showSignIn.value,
                          _buildSignUpTitle(context, fontSize16),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Obx(() {
                    return AnimatedOpacity(
                      opacity: controller.showHello.value ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: AnimatedScale(
                        scale: controller.showHello.value ? 1.0 : 0.8,
                        duration: const Duration(milliseconds: 200),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(end: 20),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: logoSize,
                            height: logoSize,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelloTitle(BuildContext context, double fontSize) {
    return Row(
      children: [
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            'hello'.tr + "!",
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              color: AppColors.background,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeTitle(BuildContext context, double fontSize) {
    return Row(
      children: [
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            'welcome'.tr,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              color: AppColors.background,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpTitle(BuildContext context, double fontSize) {
    return Row(
      children: [
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            'signup_account'.tr,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              color: AppColors.background,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget animatedText(bool show, Widget child) {
    return AnimatedOpacity(
      opacity: show ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: AnimatedSlide(
        offset: show ? const Offset(0, 0) : const Offset(0, 0.3),
        duration: const Duration(milliseconds: 200),
        child: child,
      ),
    );
  }

  // باقی متدها همان باقی می‌مانند...
  Widget inputName(BuildContext context, controller) {
    return TextFieldInnerShadow(
      borderRadius: 16,
      controller: controller,
      hintText: 'name'.tr,
      prefixIcon: const Icon(Icons.person),
      validator: (value) {
        String trimmedValue = (value ?? '').trim();
        if (trimmedValue.isEmpty) {
          return 'firstname_required'.tr;
        }
        if (trimmedValue.length < 2) {
          return 'name_too_short'.tr;
        }
        return null;
      },
      width: MediaQuery.sizeOf(context).width * 0.82,
    );
  }

  Widget inputLastName(BuildContext context, controller) {
    return TextFieldInnerShadow(
      borderRadius: 16,
      controller: controller,
      hintText: 'lastname'.tr,
      prefixIcon: const Icon(Icons.person),
      validator: (value) {
        String trimmedValue = (value ?? '').trim();
        if (trimmedValue.isEmpty) {
          return 'lastname_required'.tr;
        }
        if (trimmedValue.length < 2) {
          return 'lastname_too_short'.tr;
        }
        return null;
      },
      width: MediaQuery.sizeOf(context).width * 0.82,
    );
  }

  Widget inputEmail(BuildContext context, controller) {
    return TextFieldInnerShadow(
      borderRadius: 16,
      controller: controller,
      hintText: 'email'.tr,
      prefixIcon: const Icon(Icons.email),
      validator: (value) {
        String trimmedValue = (value ?? '').trim();
        if (trimmedValue.isEmpty) {
          return 'email_required'.tr;
        }
        if (!GetUtils.isEmail(trimmedValue)) {
          return 'email_invalid'.tr;
        }
        return null;
      },
      width: MediaQuery.sizeOf(context).width * 0.82,
    );
  }

  Widget inputPassword(BuildContext context, controller) {
    return TextFieldInnerShadow(
      borderRadius: 16,
      controller: controller,
      hintText: 'password'.tr,
      prefixIcon: const Icon(Icons.lock),
      validator: (value) {
        String trimmedValue = (value ?? '').trim();
        if (trimmedValue.isEmpty) {
          return 'password_required'.tr;
        }
        if (trimmedValue.length < 6) {
          return 'password_min_length'.tr;
        }
        return null;
      },
      width: MediaQuery.sizeOf(context).width * 0.82,
    );
  }

  Widget loginInformation(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'enter_register_info'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(width: 8),
        const ChangeLang(),
      ],
    );
  }

  Widget buttonRegister(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BoxNeumorphysm(
      onTap: controller.isLoading.value
          ? () {}
          : () {
              if (formKey.currentState!.validate()) {
                controller.registerUser(
                  name: controller.name.text.trim(),
                  lastname: controller.lastName.text.trim(),
                  phoneNumber: '',
                  email: controller.email.text.trim(),
                  password: controller.password.text.trim(),
                );
              }
            },
      borderRadius: 12,
      borderColor: isDark ? theme.dividerColor : AppColors.background,
      borderWidth: 5,
      backgroundColor: AppColors.primaryColor,
      topLeftShadowColor: isDark ? theme.highlightColor : Colors.white,
      bottomRightShadowColor: isDark
          ? theme.shadowColor.withOpacity(0.3)
          : const Color.fromARGB(255, 139, 204, 222),
      height: 60,
      width: 200,
      bottomRightOffset: const Offset(4, 4),
      topLeftOffset: const Offset(-4, -4),
      child: Center(
        child: Obx(() {
          return controller.isLoading.value
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : Text(
                  'register_account'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onPrimary,
                  ),
                );
        }),
      ),
    );
  }

  Widget buttonRegisterGoogle(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BoxNeumorphysm(
      onTap: controller.isLoadingGoogleRegister.value
          ? () {}
          : () {
              controller.registerWithGoogle();
            },
      borderRadius: 12,
      borderWidth: 5,
      backgroundColor: isDark
          ? theme.cardColor
          : const Color.fromARGB(255, 228, 238, 241),
      topLeftShadowColor: isDark ? theme.highlightColor : Colors.white,
      bottomRightShadowColor: isDark
          ? theme.shadowColor.withOpacity(0.3)
          : const Color.fromARGB(255, 139, 204, 222),
      height: 60,
      width: context.width * 0.82,
      bottomRightOffset: const Offset(4, 4),
      topLeftOffset: const Offset(-4, -4),
      child: Center(
        child: Obx(() {
          return controller.isLoadingGoogleRegister.value
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/google_icon.png',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'register_google'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                );
        }),
      ),
    );
  }

  Widget secondSection(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(child: Divider(thickness: 2, color: theme.dividerColor)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'or'.tr,
              style: TextStyle(
                fontSize: 16,
                color: theme.textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(thickness: 2, color: theme.dividerColor)),
        ],
      ),
    );
  }

  Widget SignInButton(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'have_account'.tr,
          style: TextStyle(
            fontSize: 16,
            color: theme.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        ConstantSpace.tinyHorizontalSpacer,
        TextButton(
          onPressed: () {
            Get.off(
              () => const LoginPage(),
              transition: Transition.downToUp,
              duration: const Duration(milliseconds: 400),
            );
          },
          child: Text(
            'sign_in_short'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
