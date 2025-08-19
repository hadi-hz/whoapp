import 'package:flutter/material.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/auth/presentation/pages/widgets/inner_shadow_container.dart';


class TextFieldInnerShadow extends StatelessWidget {
  TextFieldInnerShadow(
      {super.key,
      required this.controller,
      this.hintText,
      required this.validator,
      this.label,
      this.prefixIcon,
      this.suffixIcon,
      required this.width,
      required this.height,
      required this.borderRadius,
      this.maxLine});
  final double width;
  final double height;
  final double borderRadius;
  final TextEditingController controller;
  final String? hintText;
  final int? maxLine;

  final String? Function(String?)? validator;
  final Widget? label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return InnerShadowContainer(
      height: height,
      width: width,
      borderRadius: borderRadius,
      blur: 8,
      offset: const Offset(5, 5),
      shadowColor: AppColors.innershadow,
      backgroundColor: AppColors.backgroundColor,
      isShadowTopLeft: true,
      isShadowTopRight: true,
      child: TextFormField(
        maxLines: maxLine,
        controller: controller,
        validator: validator ?? (_) => null,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          label: label,
          hintText: hintText,
          enabled: true,
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondryColor,
          ),
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondryColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.red),
          ),
          floatingLabelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondryColor,
          ),
          errorStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.red,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }
}
