import 'package:skincareai/pages/auth_page.dart';
import 'package:skincareai/pages/welcome_page.dart';
import 'package:skincareai/services/auth/auth_service.dart';
import 'package:skincareai/services/photo_analyzer/photo_analyzer_api_mocked.dart';
import 'package:skincareai/services/photo_analyzer/photo_analyzer_api_remote.dart';
import 'package:skincareai/utils/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:skincareai/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AuthRemoteService().checkExistingUser();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkinCareAI',
      theme: SkinCareAIThemes.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: AuthPage(),
    );
  }
}
