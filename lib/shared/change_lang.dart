import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:test3/core/const/const.dart';

class ChangeLang extends StatelessWidget {
  const ChangeLang({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'en') {
          Get.updateLocale(const Locale('en'));
        } else if (value == 'fr') {
          Get.updateLocale(const Locale('fr'));
        } else if (value == 'it') {
          Get.updateLocale(const Locale('it'));
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'en',
          child: Row(
            children: [
              SvgPicture.asset('assets/images/england_flag.svg', width: 24),
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
          child: Icon(Icons.language, color: AppColors.background, size: 22),
        ),
      ),
    );
  }
}
