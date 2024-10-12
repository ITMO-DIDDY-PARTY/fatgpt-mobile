import 'package:fat_gpt/services/favorites/favorites_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoritesPage extends StatefulWidget {

  final FavoritesService favoritesService;

  const FavoritesPage({super.key, required this.favoritesService});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favoritesTitle),
      ),
      body: Container(),
    );
  }
}
