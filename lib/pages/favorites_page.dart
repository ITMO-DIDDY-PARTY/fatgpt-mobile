import 'dart:io';

import 'package:fat_gpt/models/recipe.dart';
import 'package:fat_gpt/pages/favorite_recipe_page.dart';
import 'package:fat_gpt/pages/recipe_page.dart';
import 'package:fat_gpt/services/favorites/favorites_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoritesPage extends StatefulWidget {
  final FavoritesService favoritesService;

  const FavoritesPage({super.key, required this.favoritesService});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Recipe> favoriteRecipes = [];

  @override
  void initState() {
    super.initState();

    widget.favoritesService.getFavorites().then((favorites) {
      setState(() {
        favoriteRecipes = favorites;
      });
    });
  }

  void _handleTapOnRecipe(Recipe recipe) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) => FavoriteRecipePage(
        recipe: recipe, isHistoryEntry: false,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favoritesTitle),
      ),
      body: SafeArea(
          child: favoriteRecipes.length == 0
              ? Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.favoritesEmpty),
                  ),
                )
              : ListView.separated(
                  itemBuilder: (context, index) {
                    final item = favoriteRecipes[index];

                    return ListTile(
                      onTap: () {
                        _handleTapOnRecipe(item);
                      },
                      leading: Image.file(File(item.photoPath)),
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
                  itemCount: favoriteRecipes.length)),
    );
  }
}
