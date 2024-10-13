
import 'package:fat_gpt/models/recipe.dart';

abstract class FavoritesService {

  Future<List<Recipe>> getFavorites();
  Future<void> addFavoriteRecipe(Recipe recipe);
}
