import 'package:fat_gpt/utils/style/colors.dart';
import 'package:flutter/material.dart';

class FatGPTThemes {

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: FatGPTColors.accent),
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
