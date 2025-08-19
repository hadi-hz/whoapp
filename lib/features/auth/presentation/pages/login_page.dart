import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/auth/presentation/pages/register_page.dart';
import 'package:test3/features/auth/presentation/pages/widgets/box_neumorphysm.dart';
import 'package:test3/features/auth/presentation/pages/widgets/checkbox.dart';
import 'package:test3/features/auth/presentation/pages/widgets/text_filed.dart';
import 'package:test3/features/home/presentation/pages/home.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      loginInformation(),
                      ConstantSpace.xLargeVerticalSpacer,
                      inputEmail(context, controller.emailLogin),
                      ConstantSpace.mediumVerticalSpacer,
                      inputPassword(context, controller.passwordLogin),
                      ConstantSpace.mediumVerticalSpacer,
                      ConstantSpace.smallVerticalSpacer,
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            checkboxRememberMe(),
                            const Spacer(),
                            forgotPassword(),
                          ],
                        ),
                      ),
                      ConstantSpace.xLargeVerticalSpacer,
                      buttonLogin(),
                      ConstantSpace.xLargeVerticalSpacer,
                      secondSection(),
                      ConstantSpace.largeVerticalSpacer,
                      registerUserButton(),
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
        offset: show ? Offset(0, 0) : Offset(0, 0.3),
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
                      signInTitle(),
                    ),
                  ),
                ],
              ),
              Spacer(),
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
          "Hello!",
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
          "Welcome to WHO",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.backgroundColor,
          ),
        ),
      ],
    );
  }

  Widget signInTitle() {
    return Row(
      children: [
        ConstantSpace.mediumHorizontalSpacer,
        Text(
          "Sign in to your Account",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.backgroundColor,
          ),
        ),
      ],
    );
  }

  Widget inputEmail(BuildContext context, controller) {
    return TextFieldInnerShadow(
      borderRadius: 16,
      controller: controller,
      height: 60,
      hintText: "Email",
      prefixIcon: const Icon(Icons.email),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Email is required";
        }
        if (!GetUtils.isEmail(value)) {
          return "Enter a valid email";
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
      height: 60,
      hintText: "Password",
      prefixIcon: const Icon(Icons.lock),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Password is required";
        }

        return null;
      },
      width: MediaQuery.sizeOf(context).width * 0.82,
    );
  }

  Widget loginInformation() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Enter your Login Information",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget buttonLogin() {
    return BoxNeumorphysm(
      onTap: controller.isLoadingLogin.value
          ? () {}
          : () {
              print(controller.emailLogin.text);
              print(controller.passwordLogin.text);

              if (formKey.currentState!.validate()) {
                controller.loginUser(
                  email: controller.emailLogin.text,
                  password: controller.passwordLogin.text,
                );
              }
              controller.emailLogin.text = ''; 
              controller.passwordLogin.text = ''; 

            },
      borderRadius: 12,
      borderWidth: 5,
      backgroundColor: const Color.fromARGB(255, 228, 238, 241),
      topLeftShadowColor: Colors.white,
      bottomRightShadowColor: const Color.fromARGB(255, 139, 204, 222),
      height: 60,
      width: 200,
      bottomRightOffset: const Offset(4, 4),
      topLeftOffset: const Offset(-4, -4),
      child: Center(
        child: Obx(() {
          return controller.isLoadingLogin.value
              ? CircularProgressIndicator(color: AppColors.primaryColor)
              : Text(
                  "LOGIN",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                );
        }),
      ),
    );
  }

  Widget forgotPassword() {
    return TextButton(
      onPressed: () {},
      child: Text(
        "Forgot Password",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget checkboxRememberMe() {
    return Row(
      children: [
        CheckBoxInnerShadow(
          width: 48,
          height: 48,
          borderRadius: 24,
          value: isChecked,
          onChanged: (val) {
            setState(() {
              isChecked = val!;
              print(isChecked);
            });
          },
        ),
        ConstantSpace.smallHorizontalSpacer,
        const Text(
          "Remember me",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget secondSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(child: Divider(thickness: 2, color: Colors.black12)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Or",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(thickness: 2, color: Colors.black12)),
        ],
      ),
    );
  }

  Widget registerUserButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        ConstantSpace.tinyHorizontalSpacer,
        TextButton(
          onPressed: () {
            Get.to(RegisterPage());
          },
          child: Text(
            "Sign Up",
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
