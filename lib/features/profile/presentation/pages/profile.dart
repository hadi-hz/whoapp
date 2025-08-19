import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/auth/presentation/pages/widgets/box_neumorphysm.dart';
import 'package:test3/features/auth/presentation/pages/widgets/text_filed.dart';
import 'package:test3/features/profile/presentation/controller/profile_controller.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

    final ProfileController controller = Get.put(ProfileController());
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: bodyTitles(context),
          ),
          Positioned(
            top: screenHeight * 0.26,
            child: Container(
              width: screenWidth,
              height: screenHeight,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstantSpace.x4LargeVerticalSpacer,
                  inputUserName(context, username),
                  ConstantSpace.mediumVerticalSpacer,
                  inputEmail(context, email),
                  ConstantSpace.mediumVerticalSpacer,
                  inputPassword(context, password),
                  ConstantSpace.mediumVerticalSpacer,
                  changePasswordButton(),
                  ConstantSpace.mediumVerticalSpacer,
                  ConstantSpace.smallVerticalSpacer,
                  ConstantSpace.xLargeVerticalSpacer,
                  buttonChangeProfile(),
                  ConstantSpace.largeVerticalSpacer,
                ],
              ),
            ),
          ),
          Positioned(
              top: screenHeight * 0.23 - 25,
              left: (screenWidth / 2) - 50,
              child: profileCircle()),
        ],
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
    height: 500,
    color: AppColors.primaryColor,
    child: Column(children: [
      ConstantSpace.largeVerticalSpacer,
      ConstantSpace.largeVerticalSpacer,

      Obx(() => Row(
            children: [
              ConstantSpace.mediumHorizontalSpacer,
              AnimatedOpacity(
                opacity: controller.showHello.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: AnimatedScale(
                  scale: controller.showHello.value ? 1.0 : 0.8,
                  duration: const Duration(milliseconds: 200),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => animatedText(controller.showHello.value, title())),
                  Obx(() => animatedText(controller.showWelcome.value, description())),
                ],
              )
            ],
          )),
    ]),
  );
}
  Widget profileCircle() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 223, 221, 221),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Icon(
            Icons.person,
            size: 50,
            color: AppColors.backgroundColor,
          ),
        ),
      ],
    );
  }

  Widget title() {
    return Row(
      children: [
        ConstantSpace.mediumHorizontalSpacer,
        Text(
          "World Health",
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.backgroundColor),
        )
      ],
    );
  }

  Widget description() {
    return Row(
      children: [
        ConstantSpace.mediumHorizontalSpacer,
        Text("Organization",
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.backgroundColor))
      ],
    );
  }

  
  Widget inputUserName(BuildContext context, controller) {
    return TextFieldInnerShadow(
      borderRadius: 16,
      controller: controller,
      height: 60,
      hintText: "Username",
      prefixIcon: const Icon(Icons.person),
      validator: (p0) {
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
      validator: (p0) {
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
      validator: (p0) {
        return null;
      },
      width: MediaQuery.sizeOf(context).width * 0.82,
    );
  }

  Widget buttonChangeProfile() {
    return BoxNeumorphysm(
      onTap: () {
        print("hello");
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
      child: const Center(
        child: Text(
          "Save Profile",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }


  Widget changePasswordButton() {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ConstantSpace.mediumHorizontalSpacer,
          Icon(Icons.lock, color: AppColors.primaryColor),
          ConstantSpace.smallHorizontalSpacer,
          Text(
            "Change Password",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor),
          )
        ],
      ),
    );
  }
}
