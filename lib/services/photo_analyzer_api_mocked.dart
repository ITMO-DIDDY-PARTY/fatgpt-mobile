import 'package:fat_gpt/services/photo_analyzer_api.dart';
import 'package:image_picker/image_picker.dart';

class PhotoAnalyzerAPIMocked implements PhotoAnalyzerApi {

  @override
  Future<String> getRecipeFromPhoto(XFile photo) {
    return Future.value("""
    # Guacamole

Some people call it guac.

*sauce, vegan*

**4 Servings, 200g**

---

- *1* avocado
- *.5 teaspoon* salt
- *1 1/2 pinches* red pepper flakes
- lemon juice

---

Remove flesh from avocado and roughly mash with fork. Season to taste with salt pepper and lemon juice.
    """);
  }
}