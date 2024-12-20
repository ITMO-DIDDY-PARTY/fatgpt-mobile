import 'package:dio/dio.dart';
import 'package:fat_gpt/components/my_button.dart';
import 'package:fat_gpt/components/my_textfield.dart';
import 'package:fat_gpt/services/auth/auth_service.dart';
import 'package:fat_gpt/utils/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {

  final AuthRemoteService authService = AuthRemoteService();
  final Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await widget.authService.authUser(emailController.text, passwordController.text);
      //pop the loading circle
      Navigator.pop(context);
    } on DioException catch (e) {
      //pop the loading circle
      Navigator.pop(context);

      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      final response = e.response;
      if (response != null) {
        genericErrorMessage((response.data["detail"] as String));

        print(response.headers);
        print(response.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    } catch (e) {
      //pop the loading circle
      Navigator.pop(context);
      genericErrorMessage(e.toString());
    }
  }

  void genericErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: <Color>[
              FatGPTColors.accentDark1,
              FatGPTColors.accentDark2,
            ],
            // Gradient from https://learnui.design/tools/gradient-generator.html
            tileMode: TileMode.mirror,
          ),
        ),
        child: SafeArea(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  AppLocalizations.of(context)!.authSignIn,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: FatGPTColors.textColor),
                ),

                const SizedBox(height: 16),

                //username
                MyTextField(
                  controller: emailController,
                  hintText: AppLocalizations.of(context)!.authUsername,
                  obscureText: false,
                ),

                const SizedBox(height: 15),
                //password
                MyTextField(
                  controller: passwordController,
                  hintText: AppLocalizations.of(context)!.authPassword,
                  obscureText: true,
                ),
                const SizedBox(height: 15),

                //sign in button
                MyButton(
                  onTap: signUserIn,
                  text: AppLocalizations.of(context)!.authSignIn,
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.authNotAMember} ",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        AppLocalizations.of(context)!.authRegisterNow,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
      ),
      ),
    );
  }
}