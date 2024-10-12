import 'package:fat_gpt/pages/welcome_page.dart';
import 'package:fat_gpt/services/photo_analyzer/photo_analyzer_api_mocked.dart';
import 'package:fat_gpt/services/photo_analyzer/photo_analyzer_api_remote.dart';
import 'package:fat_gpt/utils/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fat GPT',
      theme: FatGPTThemes.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: WelcomePage(photoAnalyzerApi: PhotoAnalyzerAPIRemote(),),
    );
  }
}
