import 'package:skincareai/utils/style/colors.dart';
import 'package:flutter/material.dart';

class SkinCareAIThemes {

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: SkinCareAIColors.accent,
      brightness: Brightness.dark,
      primary: SkinCareAIColors.accent,
      secondary: SkinCareAIColors.secondary,
      surface: SkinCareAIColors.surface,
      onSurface: SkinCareAIColors.onSurface,
    ),
    useMaterial3: true,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 26,
        height: 2,
      ),
      labelMedium: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        height: 2,
      ),
    ),
  );
}
