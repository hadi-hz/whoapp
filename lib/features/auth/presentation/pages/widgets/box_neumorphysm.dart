import 'package:flutter/material.dart';
import 'package:flutter_neumorphism_ui/flutter_neumorphism_ui.dart';

class BoxNeumorphysm extends StatelessWidget {
  BoxNeumorphysm({
    super.key,
    required this.backgroundColor,
    required this.width,
    required this.height,
    required this.bottomRightShadowColor,
    required this.topLeftShadowColor,
    required this.child,
    required this.onTap,
     this.borderColor,
    required this.borderRadius,
    required this.borderWidth,
    required this.bottomRightOffset,
    required this.topLeftOffset,
     this.boxShape,
  });

  final double width;
  final double height;
  final double? borderRadius;
  final double? borderWidth;
  final Widget child;
  final Color backgroundColor;
  final Color? borderColor;
  final Color bottomRightShadowColor;
  final Color topLeftShadowColor;
  final VoidCallback onTap;
  final BoxShape? boxShape;
  final Offset bottomRightOffset;
  final Offset topLeftOffset;

  @override
  Widget build(BuildContext context) {
    return FlutterNeumorphisms(
      boxShape: boxShape,
      width: width,
      height: height,
      child: child,
      backgroundColor: backgroundColor,
      bottomRightShadowColor: bottomRightShadowColor,
      topLeftShadowColor: topLeftShadowColor,
      onTap: onTap,
      borderColor: borderColor,
      borderRadius: borderRadius,
      bottomRightOffset: bottomRightOffset,
      topLeftOffset: topLeftOffset,
      borderWidth: borderWidth,
      bottomRightShadowBlurRadius: 16,
      bottomRightShadowSpreadRadius: 1,
      topLeftShadowBlurRadius: 16,
      topLeftShadowSpreadRadius: 1,
    );
  }
}
