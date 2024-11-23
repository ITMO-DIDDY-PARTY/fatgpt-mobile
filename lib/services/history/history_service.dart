
import 'package:fat_gpt/models/recipe.dart';

abstract class HistoryService {

  Future<List<Recipe>> getHistory();
}
