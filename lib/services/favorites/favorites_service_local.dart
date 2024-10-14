import 'package:fat_gpt/models/recipe.dart';
import 'package:fat_gpt/services/favorites/favorites_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesServiceLocal implements FavoritesService {

  final String _prefFavoritesListKey = 'favorites';

  @override
  Future<List<Recipe>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_prefFavoritesListKey)) {
      final savedTasks = prefs.getString(_prefFavoritesListKey);
      List<Recipe> loadedRecipes = (savedTasks != null)
          ? Recipe.decodeList(savedTasks)
          : <Recipe>[];
      return loadedRecipes;
    } else {
      return <Recipe>[];
    }
  }

  @override
  Future<void> addFavoriteRecipe(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    List<Recipe> savedFavorites = await getFavorites();
    savedFavorites.insert(0, recipe);
    prefs.setString(_prefFavoritesListKey, Recipe.encodeList(savedFavorites));
  }
}