import 'package:flutter/material.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/auth/presentation/pages/widgets/inner_shadow_container.dart';

class TextFieldInnerShadow extends StatelessWidget {
  TextFieldInnerShadow({
    super.key,
    required this.controller,
    this.hintText,
    required this.validator,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    required this.width,
    this.maxLine,
    this.borderRadius = 16,
  });

  final double width;
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
      width: width,
      borderRadius: borderRadius,
      blur: 8,
      offset: const Offset(5, 5),
      shadowColor: AppColors.innershadow,
      backgroundColor: AppColors.backgroundColor,
      isShadowTopLeft: true,
      isShadowTopRight: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: TextFormField(
          controller: controller,
          validator: validator ?? (_) => null,
          maxLines: maxLine ?? 1,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            label: label,
            hintText: hintText,
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
              borderSide: BorderSide.none,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none, 
            ),
            floatingLabelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondryColor,
            ),
            errorStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.red, 
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.transparent,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }
}
