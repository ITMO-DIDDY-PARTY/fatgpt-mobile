import 'dart:convert';

class Recipe {
  final String recipeContent;
  final String photoPath;

  const Recipe({required this.recipeContent, required this.photoPath});

  factory Recipe.fromJson(Map<String, dynamic> jsonData) {
    return Recipe(
      recipeContent: jsonData['content'],
      photoPath: jsonData['photoPath'],
    );
  }

  static Map<String, dynamic> toMap(Recipe recipe) => {
        'content': recipe.recipeContent,
        'photoPath': recipe.photoPath,
      };

  static String encode(Recipe recipe) => json.encode(Recipe.toMap(recipe));

  static String encodeList(List<Recipe> recipes) => json.encode(
      recipes.map<Map<String, dynamic>>((task) => Recipe.toMap(task)).toList());

  static Recipe decode(String taskString) =>
      Recipe.fromJson(json.decode(taskString));

  static List<Recipe> decodeList(String tasks) =>
      (json.decode(tasks) as List<dynamic>)
          .map<Recipe>((item) => Recipe.fromJson(item))
          .toList();
}
