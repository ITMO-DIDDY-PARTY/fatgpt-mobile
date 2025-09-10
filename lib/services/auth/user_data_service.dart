import 'package:dio/dio.dart';
import 'package:skincareai/services/network_constants.dart';
import 'package:flutter/cupertino.dart';

class UserDataService {

  final String token;

  UserDataService({ required this.token });

  Future<String> fetchUserData() async {
    print(token);
    Map<String,dynamic> queryParams = {
      "token": token
    };
    String uriString = NetworkConstants.apiUrl("/users/me");
    Response response = await Dio().get(uriString,
        queryParameters: queryParams,
        options: Options(headers: {
          "Content-Type": "application/json",
          'X-API-KEY': NetworkConstants.apiKey,
        }));

    debugPrint("[TEST] /users/me ${response.data.toString()}");

    Map responseBody = response.data;
    Map responseMap = responseBody as Map<String, dynamic>;

    return responseMap["username"];
  }
}