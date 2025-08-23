import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/core/const/const.dart';
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
      controller.runAnimations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.background,
        body: Form(
          key: formKey,
          child: Stack(
            children: [
              bodyTitles(context),

              Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * 0.72,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        loginInformation(),
                        ConstantSpace.xLargeVerticalSpacer,
                        inputName(context, controller.name),
                        ConstantSpace.mediumVerticalSpacer,
                        inputLastName(context, controller.lastName),
                        ConstantSpace.mediumVerticalSpacer,
                        inputEmail(context, controller.email),
                        ConstantSpace.mediumVerticalSpacer,
                        inputPassword(context, controller.password),
                        ConstantSpace.largeVerticalSpacer,
                        buttonRegister(),
                        ConstantSpace.xLargeVerticalSpacer,
                        secondSection(),
                        ConstantSpace.largeVerticalSpacer,
                        SignInButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 224,
      color: AppColors.primaryColor,
      child: Column(
        children: [
          ConstantSpace.xLargeVerticalSpacer,
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () =>
                        animatedText(controller.showHello.value, helloTitle()),
                  ),
                  ConstantSpace.tinyVerticalSpacer,
                  Obx(
                    () => animatedText(
                      controller.showWelcome.value,
                      welcomeTitle(),
                    ),
                  ),
                  ConstantSpace.tinyVerticalSpacer,
                  Obx(
                    () => animatedText(
                      controller.showSignIn.value,
                      signUpTitle(),
                    ),
                  ),
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

  Widget helloTitle() {
    return Row(
      children: [
        ConstantSpace.mediumHorizontalSpacer,
        Text(
          'hello'.tr + "!", 
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.backgroundColor,
          ),
        ),
      ],
    );
  }

  Widget welcomeTitle() {
    return Row(
      children: [
        ConstantSpace.mediumHorizontalSpacer,
        Text(
          'welcome'.tr, 
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.backgroundColor,
          ),
        ),
      ],
    );
  }

  Widget signUpTitle() {
    return Row(
      children: [
        ConstantSpace.mediumHorizontalSpacer,
        Text(
          'signup_account'.tr, 
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.backgroundColor,
          ),
        ),
      ],
    );
  }

  Widget inputName(BuildContext context, controller) {
    return TextFieldInnerShadow(
      borderRadius: 16,
      controller: controller,
      hintText: 'name'.tr, 
      prefixIcon: const Icon(Icons.person),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'firstname_required'.tr; 
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
        if (value == null || value.isEmpty) {
          return 'lastname_required'.tr; 
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
        if (value == null || value.isEmpty) {
          return 'email_required'.tr;
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
        if (value == null || value.isEmpty) {
          return 'password_required'.tr; 
        }
        return null;
      },
      width: MediaQuery.sizeOf(context).width * 0.82,
    );
  }

  Widget loginInformation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'enter_register_info'.tr,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        const SizedBox(width: 8),
        const ChangeLang(),
      ],
    );
  }

  Widget buttonRegister() {
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
              controller.name.text = '';
              controller.lastName.text = '';
              controller.email.text = '';
              controller.password.text = '';
            },
      borderRadius: 12,
      borderColor: AppColors.background,
      borderWidth: 5,
      backgroundColor: AppColors.primaryColor,
      topLeftShadowColor: Colors.white,
      bottomRightShadowColor: const Color.fromARGB(255, 139, 204, 222),
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
                  child: CircularProgressIndicator(color: AppColors.background),
                )
              : Text(
                  'register_account'.tr, 
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

  Widget secondSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Expanded(child: Divider(thickness: 2, color: Colors.black12)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'or'.tr, 
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(child: Divider(thickness: 2, color: Colors.black12)),
        ],
      ),
    );
  }

  Widget SignInButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'have_account'.tr, 
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        ConstantSpace.tinyHorizontalSpacer,
        TextButton(
          onPressed: () {
            Get.to(
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