import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecipePage extends StatelessWidget {
  final String recipeContent;

  const RecipePage({super.key, required this.recipeContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.recipeTitle),
      ),
      body: Material(
      child: Container(
        child: Markdown(data: recipeContent),
      ),
    ),);
  }
}
