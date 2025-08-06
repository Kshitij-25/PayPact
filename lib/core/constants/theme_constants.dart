import 'package:flutter/material.dart';

class ThemeConstants {
  final bool isDarkMode;
  final Color shadowColor;
  final Color lightShadow;

  ThemeConstants(BuildContext context)
    : isDarkMode = Theme.of(context).brightness == Brightness.dark,
      shadowColor = Theme.of(context).brightness == Brightness.dark ? Colors.black54 : Colors.white,
      lightShadow = Theme.of(context).brightness == Brightness.dark ? Colors.black38 : Colors.grey.shade400;
}
