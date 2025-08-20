import 'package:dio/dio.dart';
import 'package:skincareai/components/my_button.dart';
import 'package:skincareai/components/my_textfield.dart';
import 'package:skincareai/services/auth/auth_service.dart';
import 'package:skincareai/utils/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:skincareai/l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {

  final AuthRemoteService authService = AuthRemoteService();
  final Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await widget.authService.registerUser(emailController.text, passwordController.text);

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
          content: SingleChildScrollView(child: Text(message)),
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
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: <Color>[
              SkinCareAIColors.accentDark1,
              SkinCareAIColors.accentDark2,
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
                  AppLocalizations.of(context)!.authRegister,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: SkinCareAIColors.textColor),
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
                //
                // MyTextField(
                //   controller: confirmPasswordController,
                //   hintText: 'Confirm Password',
                //   obscureText: true,
                // ),
                // const SizedBox(height: 15),

                //sign in button
                MyButton(
                  onTap: signUserUp,
                  text: AppLocalizations.of(context)!.authRegister,
                ),
                const SizedBox(height: 20),

                // not a memeber ? register now

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.authAlreadyHaveAnAccount +
                          " ",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        AppLocalizations.of(context)!.authLoginNow,
                        style: TextStyle(
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
