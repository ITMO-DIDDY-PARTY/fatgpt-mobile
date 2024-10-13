import 'package:image_picker/image_picker.dart';

abstract class PhotoAnalyzerApi {

  Future<String> getRecipeFromPhoto(XFile photo);
}
