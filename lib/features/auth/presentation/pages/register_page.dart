import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/auth/presentation/controller/auth_controller.dart';
import 'package:test3/features/auth/presentation/pages/login_page.dart';
import 'package:test3/features/auth/presentation/pages/widgets/box_neumorphysm.dart';
import 'package:test3/features/auth/presentation/pages/widgets/text_filed.dart';

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
                    width: double.infinity,
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

  Widget signUpTitle() {
    return Row(
      children: [
        ConstantSpace.mediumHorizontalSpacer,
        Text(
          "Sign Up Account",
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
      height: 60,
      hintText: "name",
      prefixIcon: const Icon(Icons.person),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "First name is required";
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
      height: 60,
      hintText: "lastname",
      prefixIcon: const Icon(Icons.person),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Last name is required";
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
      height: 60,
      hintText: "Email",
      prefixIcon: const Icon(Icons.email),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Email is required";
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
          "Enter your Information for Register",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
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
                  name: controller.name.text,
                  lastname: controller.lastName.text,
                  phoneNumber: 'phoneController.text',
                  email: controller.email.text,
                  password: controller.password.text,
                );
              }
              controller.name.text = '';
              controller.lastName.text = '';
              controller.email.text = '';
              controller.password.text = '';
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
          return controller.isLoading.value
              ? CircularProgressIndicator(color: AppColors.primaryColor)
              : Text(
                  "Register Account",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                );
        }),
      ),
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

  Widget SignInButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "have an account?",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        ConstantSpace.tinyHorizontalSpacer,
        TextButton(
          onPressed: () {
            Get.to(const LoginPage());
          },
          child: Text(
            "Sign In",
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
