import 'package:fat_gpt/models/user.dart';
import 'package:fat_gpt/pages/welcome_page.dart';
import 'package:fat_gpt/services/auth/auth_service.dart';
import 'package:fat_gpt/services/auth/user_data_service.dart';
import 'package:fat_gpt/services/photo_analyzer/photo_analyzer_api_remote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_or_register_page.dart';

class AuthPage extends StatelessWidget {

  final AuthRemoteService authRemoteService = AuthRemoteService();

  AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: authRemoteService.userDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // user logged in
            String token = snapshot.data!.token;
            return WelcomePage(
              userId: token,
              photoAnalyzerApi: PhotoAnalyzerAPIRemote(token: token),
              userDataService: UserDataService(token: token),
            );
          } else {
            // user not logged in
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}