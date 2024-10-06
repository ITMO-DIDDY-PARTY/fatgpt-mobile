import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class RecipePage extends StatelessWidget {
  final String recipeContent;

  const RecipePage({super.key, required this.recipeContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Recipe'),
      ),
      body: Material(
      child: Container(
        child: Markdown(data: recipeContent),
      ),
    ),);
  }
}
