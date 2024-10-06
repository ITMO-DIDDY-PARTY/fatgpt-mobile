import 'dart:ui';

import 'package:fat_gpt/pages/recipe_page.dart';
import 'package:fat_gpt/services/photo_analyzer_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/style/colors.dart';

class WelcomePage extends StatelessWidget {
  final PhotoAnalyzerApi photoAnalyzerApi;

  const WelcomePage({
    super.key,
    required this.photoAnalyzerApi,
  });

  void _handleTapOnGetStarted(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      String recipe = await photoAnalyzerApi.getRecipeFromPhoto(image);
      Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) => RecipePage(recipeContent: recipe),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
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
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Image(image: AssetImage('images/logo.png')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        Text(
                          AppLocalizations.of(context)!.appTitle,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: FatGPTColors.textColor),
                        ),
                        Text(
                          AppLocalizations.of(context)!.appDescription,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: FatGPTColors.textColor),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 64,
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FatGPTColors.accent,
                    minimumSize: Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    _handleTapOnGetStarted(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.welcomeGetStarted,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: FatGPTColors.accentButtonTextColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
