import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:fat_gpt/services/photo_analyzer_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class PhotoAnalyzerAPIRemote implements PhotoAnalyzerApi {
  @override
  Future<String> getRecipeFromPhoto(XFile photo) async {
    Uint8List bytes = await photo.readAsBytes();
    String bytesString = bytes.toString();
    // String bytesString = base64Encode(bytes);
    final params = {
      'type': 'breakfast',
    };
    Map<String, String> headers = {
      "X-API-KEY": "arsenmarkaryanfanclub20241008",
      // "content-type": "multipart/form-data"
    };
    String uriString = 'http://134.209.136.171:8000/generate';

    // Uri uri = Uri.parse(uriString).replace(queryParameters: params);

    FormData formData = FormData.fromMap(
        {"file": MultipartFile.fromBytes(bytes, filename: "file.jpg")});

    Response response = await Dio().post(uriString,
        data: formData,
        options: Options(headers: {
          "Content-Type": "multipart/form-data",
          'X-API-KEY': "arsenmarkaryanfanclub20241008"
        }));

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
