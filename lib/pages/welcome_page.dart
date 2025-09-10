import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:skincareai/models/recipe.dart';
import 'package:skincareai/pages/favorites_page.dart';
import 'package:skincareai/pages/recipe_page.dart';
import 'package:skincareai/services/auth/auth_service.dart';
import 'package:skincareai/services/auth/user_data_service.dart';
import 'package:skincareai/services/favorites/favorites_service_local.dart';
import 'package:skincareai/services/history/history_service_remote.dart';
import 'package:skincareai/services/photo_analyzer/photo_analyzer_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:skincareai/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/style/colors.dart';
import 'history_page.dart';

class WelcomePage extends StatefulWidget {
  final String userId;
  final PhotoAnalyzerApi photoAnalyzerApi;
  final AuthRemoteService authRemoteService = AuthRemoteService();
  final UserDataService userDataService;

  WelcomePage({
    super.key,
    required this.userId,
    required this.photoAnalyzerApi,
    required this.userDataService,
  });

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isLoading = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      String fetchedUserId = await widget.userDataService.fetchUserData();
      setState(() {
        userId = fetchedUserId;
      });
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      final response = e.response;
      if (response != null) {
        print(response.headers);
        print(response.data);
        print(response.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    } catch (e) {
      //pop the loading circle
      print(e.toString());
    }
  }

  void _handleTapOnGetStarted(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      try {
        String recipeContent =
            await widget.photoAnalyzerApi.getRecipeFromPhoto(image);
        Recipe recipe =
            Recipe(recipeContent: recipeContent, photoPath: image.path);
        Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext context) => RecipePage(
            recipe: recipe,
            photoAnalyzerApi: widget.photoAnalyzerApi,
            favoritesService: FavoritesServiceLocal(),
          ),
        ));
      } catch (error) {
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.error),
              content: Text(error.toString()),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void _handleGoToFavorites() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) =>
          FavoritesPage(favoritesService: FavoritesServiceLocal()),
    ));
  }

  void _handleGoToHistory() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => HistoryPage(
          historyService: HistoryServiceRemote(token: widget.userId),
        ),
      ),
    );
  }

  void _handleLogout() {
    widget.authRemoteService.logOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: _handleLogout,
            icon: Icon(Icons.logout),
            iconSize: 36,
            color: SkinCareAIColors.accent,
          ),
          Spacer(),
          IconButton(
            onPressed: _handleGoToHistory,
            icon: Icon(Icons.history),
            iconSize: 36,
            color: SkinCareAIColors.accent,
          ),
          IconButton(
            onPressed: _handleGoToFavorites,
            icon: Icon(Icons.favorite),
            iconSize: 36,
            color: SkinCareAIColors.accent,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: <Color>[
              SkinCareAIColors.accentDark1,
              SkinCareAIColors.accentDark2,
            ],
            // Gradient from https://learnui.design/tools/gradient-generator.html
            tileMode: TileMode.mirror,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Image(
                  image: AssetImage('images/logo.png'),
                  width: 100,
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        Text(
                          AppLocalizations.of(context)!.appTitle,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: SkinCareAIColors.textColor),
                        ),
                        Text(
                          AppLocalizations.of(context)!.appDescription,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: SkinCareAIColors.textColor),
                        ),
                        Text(
                          "${AppLocalizations.of(context)!.welcomYourId} ${userId ?? "unknown"}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 64,
                ),
                Spacer(),
                () {
                  return isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SkinCareAIColors.accent,
                            minimumSize: Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            _handleTapOnGetStarted(context);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.welcomeGetStarted,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    color: SkinCareAIColors.accentButtonTextColor),
                          ),
                        );
                }()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
