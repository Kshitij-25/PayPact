import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

import '../../core/constants/theme_constants.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    this.height,
    this.width,
    required this.child,
    this.padding,
    this.shape,
    this.radius,
    this.inset = false,
    this.color,
  });

  final double? height;
  final double? width;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BoxShape? shape;
  final double? radius;
  final bool inset;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? (ThemeConstants(context).isDarkMode ? Theme.of(context).cardColor : const Color(0xFFE7EBF0)),
        borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(radius ?? 10),
        shape: shape ?? BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: ThemeConstants(context).lightShadow,
            offset: Offset(2.5, 2.5),
            blurRadius: 5,
            inset: inset,
          ),
          BoxShadow(
            color: ThemeConstants(context).shadowColor,
            offset: Offset(-2.5, -2.5),
            blurRadius: 5,
            inset: inset,
          ),
        ],
      ),
      child: child,
    );
  }
}
