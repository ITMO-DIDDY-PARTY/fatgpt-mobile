import 'dart:io';

import 'package:fat_gpt/models/recipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoriteRecipePage extends StatelessWidget {
  final Recipe recipe;

  const FavoriteRecipePage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.recipeTitle),
        actions: [
          IconButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (_) => _RecipePhotoDialog(
                          path: recipe.photoPath,
                        ));
              },
              icon: Icon(Icons.photo))
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

class _RecipePhotoDialog extends StatelessWidget {
  final String path;

  const _RecipePhotoDialog({required this.path});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Image.file(
        File(path),
      ),
    );
  }
}
