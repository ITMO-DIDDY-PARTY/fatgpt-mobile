import 'package:skincareai/models/recipe.dart';

abstract class FavoritesService {

  Future<List<Recipe>> getFavorites();
  Future<void> addFavoriteRecipe(Recipe recipe);
}
