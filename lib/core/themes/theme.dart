import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff2c5288),
      surfaceTint: Color(0xff3a5f96),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff466aa2),
      onPrimaryContainer: Color(0xffe2eaff),
      secondary: Color(0xff535f74),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff8f9bb2),
      onSecondaryContainer: Color(0xff273346),
      tertiary: Color(0xff703f74),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8a578e),
      onTertiaryContainer: Color(0xffffe1fc),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xFFE7EBF0),
      onSurface: Color(0xff1c1b1c),
      onSurfaceVariant: Color(0xff43474f),
      outline: Color(0xff737781),
      outlineVariant: Color(0xffc3c6d1),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffa9c7ff),
      primaryFixed: Color(0xffd6e3ff),
      onPrimaryFixed: Color(0xff001b3d),
      primaryFixedDim: Color(0xffa9c7ff),
      onPrimaryFixedVariant: Color(0xff1f477d),
      secondaryFixed: Color(0xffd7e3fc),
      onSecondaryFixed: Color(0xff101c2e),
      secondaryFixedDim: Color(0xffbbc7df),
      onSecondaryFixedVariant: Color(0xff3b475b),
      tertiaryFixed: Color(0xffffd6fd),
      onTertiaryFixed: Color(0xff33053a),
      tertiaryFixedDim: Color(0xffefb3f0),
      onTertiaryFixedVariant: Color(0xff643569),
      surfaceDim: Color(0xffdcd9d9),
      surfaceBright: Color(0xfffcf8f8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f3f3),
      surfaceContainer: Color(0xfff0eded),
      surfaceContainerHigh: Color(0xffebe7e7),
      surfaceContainerHighest: Color(0xffe5e2e1),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff04366b),
      surfaceTint: Color(0xff3a5f96),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff466aa2),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2b374a),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff626e83),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff512457),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8a578e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf8f8),
      onSurface: Color(0xff111111),
      onSurfaceVariant: Color(0xff32363f),
      outline: Color(0xff4f525b),
      outlineVariant: Color(0xff696d76),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffa9c7ff),
      primaryFixed: Color(0xff4a6ea6),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff30558c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff626e83),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff49556a),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff8e5b92),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff734378),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc8c6c6),
      surfaceBright: Color(0xfffcf8f8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f3f3),
      surfaceContainer: Color(0xffebe7e7),
      surfaceContainerHigh: Color(0xffdfdcdc),
      surfaceContainerHighest: Color(0xffd4d1d1),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002c5b),
      surfaceTint: Color(0xff3a5f96),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff22497f),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff212d3f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff3e4a5e),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff46194c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff67376c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf8f8),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff282c34),
      outlineVariant: Color(0xff454952),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffa9c7ff),
      primaryFixed: Color(0xff22497f),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003266),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff3e4a5e),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff273346),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff67376c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff4d2053),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbbb8b8),
      surfaceBright: Color(0xfffcf8f8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f0f0),
      surfaceContainer: Color(0xffe5e2e1),
      surfaceContainerHigh: Color(0xffd7d4d3),
      surfaceContainerHighest: Color(0xffc8c6c6),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa9c7ff),
      surfaceTint: Color(0xffa9c7ff),
      onPrimary: Color(0xff003062),
      primaryContainer: Color(0xff466aa2),
      onPrimaryContainer: Color(0xffe2eaff),
      secondary: Color(0xffbbc7df),
      onSecondary: Color(0xff253144),
      secondaryContainer: Color(0xff8f9bb2),
      onSecondaryContainer: Color(0xff273346),
      tertiary: Color(0xffefb3f0),
      onTertiary: Color(0xff4b1e51),
      tertiaryContainer: Color(0xff8a578e),
      onTertiaryContainer: Color(0xffffe1fc),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff131314),
      onSurface: Color(0xffe5e2e1),
      onSurfaceVariant: Color(0xffc3c6d1),
      outline: Color(0xff8d919a),
      outlineVariant: Color(0xff43474f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff3a5f96),
      primaryFixed: Color(0xffd6e3ff),
      onPrimaryFixed: Color(0xff001b3d),
      primaryFixedDim: Color(0xffa9c7ff),
      onPrimaryFixedVariant: Color(0xff1f477d),
      secondaryFixed: Color(0xffd7e3fc),
      onSecondaryFixed: Color(0xff101c2e),
      secondaryFixedDim: Color(0xffbbc7df),
      onSecondaryFixedVariant: Color(0xff3b475b),
      tertiaryFixed: Color(0xffffd6fd),
      onTertiaryFixed: Color(0xff33053a),
      tertiaryFixedDim: Color(0xffefb3f0),
      onTertiaryFixedVariant: Color(0xff643569),
      surfaceDim: Color(0xff131314),
      surfaceBright: Color(0xff3a3939),
      surfaceContainerLowest: Color(0xff0e0e0e),
      surfaceContainerLow: Color(0xff1c1b1c),
      surfaceContainer: Color(0xff201f20),
      surfaceContainerHigh: Color(0xff2a2a2a),
      surfaceContainerHighest: Color(0xff353535),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffccddff),
      surfaceTint: Color(0xffa9c7ff),
      onPrimary: Color(0xff00254f),
      primaryContainer: Color(0xff6e92cc),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffd1ddf6),
      onSecondary: Color(0xff1a2638),
      secondaryContainer: Color(0xff8f9bb2),
      onSecondaryContainer: Color(0xff010a1c),
      tertiary: Color(0xffffccff),
      onTertiary: Color(0xff3f1245),
      tertiaryContainer: Color(0xffb57eb8),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff131314),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd9dce7),
      outline: Color(0xffaeb2bc),
      outlineVariant: Color(0xff8d909a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff20487e),
      primaryFixed: Color(0xffd6e3ff),
      onPrimaryFixed: Color(0xff00112a),
      primaryFixedDim: Color(0xffa9c7ff),
      onPrimaryFixedVariant: Color(0xff04366b),
      secondaryFixed: Color(0xffd7e3fc),
      onSecondaryFixed: Color(0xff051123),
      secondaryFixedDim: Color(0xffbbc7df),
      onSecondaryFixedVariant: Color(0xff2b374a),
      tertiaryFixed: Color(0xffffd6fd),
      onTertiaryFixed: Color(0xff25002b),
      tertiaryFixedDim: Color(0xffefb3f0),
      onTertiaryFixedVariant: Color(0xff512457),
      surfaceDim: Color(0xff131314),
      surfaceBright: Color(0xff454444),
      surfaceContainerLowest: Color(0xff070708),
      surfaceContainerLow: Color(0xff1e1d1e),
      surfaceContainer: Color(0xff282828),
      surfaceContainerHigh: Color(0xff333233),
      surfaceContainerHighest: Color(0xff3e3d3e),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffebf0ff),
      surfaceTint: Color(0xffa9c7ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa2c4ff),
      onPrimaryContainer: Color(0xff000b1f),
      secondary: Color(0xffeaf0ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffb7c3db),
      onSecondaryContainer: Color(0xff010b1d),
      tertiary: Color(0xffffeafb),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffeaafec),
      onTertiaryContainer: Color(0xff1b0021),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color.from(alpha: 1, red: 0.133, green: 0, blue: 0.004),
      surface: Color(0xff131314),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffedf0fb),
      outlineVariant: Color(0xffbfc2cd),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff20487e),
      primaryFixed: Color(0xffd6e3ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffa9c7ff),
      onPrimaryFixedVariant: Color(0xff00112a),
      secondaryFixed: Color(0xffd7e3fc),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffbbc7df),
      onSecondaryFixedVariant: Color(0xff051123),
      tertiaryFixed: Color(0xffffd6fd),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffefb3f0),
      onTertiaryFixedVariant: Color(0xff25002b),
      surfaceDim: Color(0xff131314),
      surfaceBright: Color(0xff515050),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff201f20),
      surfaceContainer: Color(0xff313030),
      surfaceContainerHigh: Color(0xff3c3b3b),
      surfaceContainerHighest: Color(0xff474647),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
