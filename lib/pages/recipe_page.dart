import 'package:fat_gpt/models/recipe.dart';
import 'package:fat_gpt/services/photo_analyzer/photo_analyzer_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class RecipePage extends StatefulWidget {
  final Recipe recipe;
  final PhotoAnalyzerApi photoAnalyzerApi;

  const RecipePage(
      {super.key, required this.recipe, required this.photoAnalyzerApi});

  @override
  State<RecipePage> createState() => _RecipePageState(recipe: recipe);
}

class _RecipePageState extends State<RecipePage> {
  bool isLoading = false;
  Recipe recipe;

  _RecipePageState({required this.recipe});

  void _regenerate() async {
    setState(() {
      isLoading = true;
    });
    XFile photo = XFile(recipe.photoPath);
    String newRecipeContent =
        await widget.photoAnalyzerApi.getRecipeFromPhoto(photo);
    Recipe newRecipe =
        Recipe(recipeContent: newRecipeContent, photoPath: recipe.photoPath);
    setState(() {
      recipe = newRecipe;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.recipeTitle),
        actions: isLoading
            ? [
                const SizedBox(
                  child: Center(child: CircularProgressIndicator()),
                  height: 20.0,
                  width: 20.0,
                ),
                const SizedBox(
                  width: 16,
                )
              ]
            : [
                IconButton(
                  onPressed: () => _regenerate(),
                  icon: Icon(Icons.refresh),
                ),
              ],
      ),
      body: Material(
        child: Container(
          child: Markdown(data: recipe.recipeContent),
        ),
      ),
    );
  }
}
