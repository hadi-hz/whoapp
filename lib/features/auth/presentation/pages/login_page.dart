import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/auth/presentation/pages/register_page.dart';
import 'package:test3/features/auth/presentation/pages/widgets/box_neumorphysm.dart';
import 'package:test3/features/auth/presentation/pages/widgets/text_filed.dart';
import 'package:test3/shared/change_lang.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();

  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.runAnimations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark ? theme.scaffoldBackgroundColor : AppColors.background,
        body: Stack(
          children: [
            Positioned(top: 0, left: 0, right: 0, child: bodyTitles(context)),
            Positioned(
              top: screenHeight * 0.23,
              child: Form(
                key: formKey,
                child: Container(
                  width: screenWidth,
                  height: screenHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: isDark 
                            ? Colors.black.withOpacity(0.3)
                            : Colors.black12,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      loginInformation(context),
                      ConstantSpace.xLargeVerticalSpacer,
                      inputEmail(context, controller.emailLogin),
                      ConstantSpace.mediumVerticalSpacer,
                      inputPassword(context, controller.passwordLogin),
                      ConstantSpace.smallVerticalSpacer,
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                        child: Row(
                          children: [const Spacer(), forgotPassword(context)],
                        ),
                      ),
                      ConstantSpace.mediumVerticalSpacer,
                      buttonLogin(context),
                      ConstantSpace.mediumVerticalSpacer,
                      secondSection(context),
                      ConstantSpace.mediumVerticalSpacer,
                      buttonLoginGoogle(context),
                      ConstantSpace.mediumVerticalSpacer,
                      registerUserButton(context),
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

  Widget bodyTitles(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 224,
      color: isDark ? theme.primaryColor : AppColors.primaryColor,
      child: Column(
        children: [
          ConstantSpace.xLargeVerticalSpacer,
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => animatedText(controller.showHello.value, helloTitle(context))),
                  ConstantSpace.tinyVerticalSpacer,
                  Obx(() => animatedText(controller.showWelcome.value, welcomeTitle(context))),
                  ConstantSpace.tinyVerticalSpacer,
                  Obx(() => animatedText(controller.showSignIn.value, signInTitle(context))),
                ],
              ),
              const Spacer(),
              Obx(() {
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
                        width: 130,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget helloTitle(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        ConstantSpace.mediumHorizontalSpacer,
        Text(
          'hello'.tr + "!",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }

  Widget welcomeTitle(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        ConstantSpace.mediumHorizontalSpacer,
        Text(
          'welcome'.tr,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }

  Widget signInTitle(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        ConstantSpace.mediumHorizontalSpacer,
        Text(
          'sign_in'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ],
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
          'enter_login_info'.tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(width: 8),
        const ChangeLang(),
      ],
    );
  }

  Widget buttonLoginGoogle(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return BoxNeumorphysm(
      onTap: controller.isLoadingGoogle.value
          ? () {}
          : () {
              controller.loginWithGoogle();
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
          return controller.isLoadingGoogle.value
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: AppColors.primaryColor),
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
                      'login_google'.tr,
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

  Widget buttonLogin(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return BoxNeumorphysm(
      borderColor: isDark ? theme.dividerColor : Colors.white,
      onTap: controller.isLoadingLogin.value
          ? () {}
          : () {
              if (formKey.currentState!.validate()) {
                controller.loginUser(
                  email: controller.emailLogin.text.trim(),
                  password: controller.passwordLogin.text.trim(),
                );
              }
              controller.emailLogin.text = '';
              controller.passwordLogin.text = '';
            },
      borderRadius: 12,
      borderWidth: 5,
      backgroundColor: AppColors.primaryColor,
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
          return controller.isLoadingLogin.value
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: theme.colorScheme.onPrimary),
                )
              : Text(
                  'login'.tr,
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

  Widget registerUserButton(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'no_account'.tr,
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
              () => const RegisterPage(),
              transition: Transition.downToUp,
              duration: const Duration(milliseconds: 400),
            );
          },
          child: Text(
            'sign_up'.tr,
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

  Widget forgotPassword(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(
        'forgot_password'.tr,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}