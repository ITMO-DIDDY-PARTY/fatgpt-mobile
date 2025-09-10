import 'package:dio/dio.dart';
import 'package:skincareai/models/recipe.dart';
import 'package:skincareai/services/network_constants.dart';
import 'package:flutter/cupertino.dart';

import 'history_service.dart';

class HistoryServiceRemote extends HistoryService {
  final String token;

  HistoryServiceRemote({required this.token});

  @override
  Future<List<Recipe>> getHistory() async {
    print(token);
    Map<String, dynamic> queryParams = {"token": token};
    String uriString = NetworkConstants.apiUrl("/history");
    Response response = await Dio().get(uriString,
        queryParameters: queryParams,
        options: Options(headers: {
          "Content-Type": "application/json",
          'X-API-KEY': NetworkConstants.apiKey,
        }));

    debugPrint("[TEST] /history ${response.data.toString()}");

    List<dynamic> responseBody = response.data;
    List<_GenerateRecipeResponse> rawObjects = responseBody.map((element) {
      return _GenerateRecipeResponse.fromJson(element);
    }).toList();

    return rawObjects.reversed.map((element) {
      return Recipe(
          recipeContent: element.markdown, photoPath: element.s3_image);
    }).toList();
  }
}

class _GenerateRecipeResponse {
  final int id;
  final String markdown;
  final String s3_image;

  _GenerateRecipeResponse(
      {required this.id, required this.markdown, required this.s3_image});

  factory _GenerateRecipeResponse.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'markdown': String markdown,
        's3_image': String s3_image,
      } =>
        _GenerateRecipeResponse(
          id: id,
          markdown: markdown,
          s3_image: 'http://104.248.140.209:7991/static/' + s3_image,
        ),
      _ => throw const FormatException('Failed to load generation response.'),
    };
  }
}
