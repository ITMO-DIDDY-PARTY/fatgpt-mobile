import 'dart:io';

import 'package:fat_gpt/models/recipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoriteRecipePage extends StatelessWidget {
  final Recipe recipe;
  final bool isHistoryEntry;

  const FavoriteRecipePage(
      {super.key, required this.recipe, required this.isHistoryEntry});

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
                    isHistoryEntry: isHistoryEntry,
                    path: recipe.photoPath,
                  ),
                );
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
  final bool isHistoryEntry;

  const _RecipePhotoDialog({required this.path, required this.isHistoryEntry});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: isHistoryEntry
          ? Image.network(path)
          : Image.file(
              File(path),
            ),
    );
  }
}
