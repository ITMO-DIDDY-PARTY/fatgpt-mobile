import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:fat_gpt/services/network_constants.dart';
import 'package:fat_gpt/services/photo_analyzer/photo_analyzer_api.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';

class PhotoAnalyzerAPIRemote implements PhotoAnalyzerApi {
  final String token;

  PhotoAnalyzerAPIRemote({required this.token});

  @override
  Future<String> getRecipeFromPhoto(XFile photo) async {
    Uint8List bytes = await photo.readAsBytes();

    String uriString = NetworkConstants.apiUrl('/generate');

    Map<String, dynamic> queryParams = {"token": token};

    FormData formData = FormData.fromMap(
      {
        "file": MultipartFile.fromBytes(bytes, filename: "${DateTime.now().toString()}.jpg"),
      },
    );

    Response response = await Dio().post(
      uriString,
      data: formData,
      queryParameters: queryParams,
      options: Options(headers: {
        "Content-Type": "multipart/form-data",
        'X-API-KEY': NetworkConstants.apiKey,
      }),
    );

    log("[TEST] ${response.data.toString()}");
    Map responseBody = response.data;

    return GenerateRecipeResponse.fromJson(responseBody as Map<String, dynamic>)
        .markdown;
  }
}

class GenerateRecipeRequest {
  final String file;

  GenerateRecipeRequest({required this.file});
}

class GenerateRecipeResponse {
  final String markdown;

  GenerateRecipeResponse({required this.markdown});

  factory GenerateRecipeResponse.fromJson(Map<String, dynamic> json) {
    log(json.toString());
    return switch (json) {
      {'markdown': String markdown} =>
        GenerateRecipeResponse(markdown: markdown),
      _ => throw const FormatException('Failed to load generation response.'),
    };
  }
}
