
import 'package:skincareai/models/recipe.dart';

abstract class HistoryService {

  Future<List<Recipe>> getHistory();
}
