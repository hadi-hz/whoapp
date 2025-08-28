import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/auth/presentation/controller/translation_controller.dart';

class ChangeLang extends StatelessWidget {
  const ChangeLang({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageController languageController = Get.find<LanguageController>();

    return Obx(() => PopupMenuButton<String>(
      enabled: !languageController.isChangingLanguage.value,
      onSelected: (value) async {
        await languageController.changeLanguage(value);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'en',
          child: Row(
            children: [
              SvgPicture.asset('assets/images/en.svg', width: 24),
              const SizedBox(width: 8),
              const Text("English"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'fr',
          child: Row(
            children: [
              SvgPicture.asset('assets/images/france_flag.svg', width: 24),
              const SizedBox(width: 8),
              const Text("French"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'it',
          child: Row(
            children: [
              SvgPicture.asset('assets/images/itly_flag.svg', width: 24),
              const SizedBox(width: 8),
              const Text("Italian"),
            ],
          ),
        ),
      ],
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: languageController.isChangingLanguage.value
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.background,
                  ),
                )
              : Icon(Icons.language, color: AppColors.background, size: 22),
        ),
      ),
    ));
  }
}