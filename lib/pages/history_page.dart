import 'dart:io';

import 'package:skincareai/models/recipe.dart';
import 'package:skincareai/pages/favorite_recipe_page.dart';
import 'package:skincareai/pages/recipe_page.dart';
import 'package:skincareai/services/favorites/favorites_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:skincareai/l10n/app_localizations.dart';

import '../services/history/history_service.dart';

class HistoryPage extends StatefulWidget {
  final HistoryService historyService;

  const HistoryPage({super.key, required this.historyService});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();

    widget.historyService.getHistory().then((historyEntries) {
      setState(() {
        recipes = historyEntries;
      });
    });
  }

  void _handleTapOnRecipe(Recipe recipe) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) => FavoriteRecipePage(
        recipe: recipe, isHistoryEntry: true,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.historyTitle),
      ),
      body: SafeArea(
          child: recipes.length == 0
              ? Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(AppLocalizations.of(context)!.favoritesEmpty),
            ),
          )
              : ListView.separated(
              itemBuilder: (context, index) {
                final item = recipes[index];

                return ListTile(
                  onTap: () {
                    _handleTapOnRecipe(item);
                  },
                  leading: Image.network(item.photoPath),
                  subtitle: SizedBox(
                    child: Text(
                      item.recipeContent,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: recipes.length)),
    );
  }
}
