import 'package:flutter/material.dart';
import 'package:test3/core/const/const.dart';
import 'package:test3/features/auth/presentation/pages/widgets/inner_shadow_container.dart';



class CheckBoxInnerShadow extends StatefulWidget {
  const CheckBoxInnerShadow({
    super.key,
    required this.width,
    required this.height,
    required this.borderRadius,
    this.value = false,
    this.onChanged,
  });

  final double width;
  final double height;
  final double borderRadius;
  final bool value;
  final void Function(bool?)? onChanged;

  @override
  State<CheckBoxInnerShadow> createState() => _CheckBoxInnerShadowState();
}

class _CheckBoxInnerShadowState extends State<CheckBoxInnerShadow> {
  @override
  Widget build(BuildContext context) {
    return InnerShadowContainer(
      width: widget.width,
      height: widget.height,
      borderRadius: widget.borderRadius,
      blur: 8,
      offset: const Offset(4, 4),
      shadowColor: AppColors.innershadow,
      backgroundColor: AppColors.backgroundColor,
      isShadowTopLeft: true,
      isShadowTopRight: true,
      isShadowBottomLeft: true,
      isShadowBottomRight: true,
      child: Center(
        child: Transform.scale(
          scale: 1.4,
          child: Checkbox(
            activeColor: AppColors.primaryColor,
            checkColor: AppColors.backgroundColor,
            shape: const CircleBorder(),
            side: BorderSide.none,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            value: widget.value,
            onChanged: widget.onChanged,
          ),
        ),
      ),
    );
  }
}
