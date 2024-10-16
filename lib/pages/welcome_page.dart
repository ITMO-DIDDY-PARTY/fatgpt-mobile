import 'dart:ui';

import 'package:fat_gpt/models/recipe.dart';
import 'package:fat_gpt/pages/favorites_page.dart';
import 'package:fat_gpt/pages/recipe_page.dart';
import 'package:fat_gpt/services/favorites/favorites_service_local.dart';
import 'package:fat_gpt/services/photo_analyzer/photo_analyzer_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/style/colors.dart';

class WelcomePage extends StatefulWidget {
  final PhotoAnalyzerApi photoAnalyzerApi;

  const WelcomePage({
    super.key,
    required this.photoAnalyzerApi,
  });

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isLoading = false;

  void _handleTapOnGetStarted(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      try {
        String recipeContent = await widget.photoAnalyzerApi.getRecipeFromPhoto(image);
        Recipe recipe = Recipe(recipeContent: recipeContent, photoPath: image.path);
        Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext context) => RecipePage(
            recipe: recipe,
            photoAnalyzerApi: widget.photoAnalyzerApi,
            favoritesService: FavoritesServiceLocal(),
          ),
        ));
      } catch (error) {
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.error),
              content: Text(error.toString()),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void _handleGoToFavorites() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) =>
          FavoritesPage(favoritesService: FavoritesServiceLocal()),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: _handleGoToFavorites,
            icon: Icon(Icons.favorite),
            iconSize: 36,
            color: FatGPTColors.accent,
          ),
        ],
      ),
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
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Image(
                  image: AssetImage('images/logo.png'),
                  width: 100,
                  height: 100,
                ),
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
                () {
                  return isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
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
                                ?.copyWith(
                                    color: FatGPTColors.accentButtonTextColor),
                          ),
                        );
                }()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
