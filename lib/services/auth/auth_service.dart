import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fat_gpt/models/user.dart';
import 'package:fat_gpt/services/network_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthConstants {

  static const String tokenStorageKey = "token";
}

class AuthRemoteService {

  static final AuthRemoteService _singleton = AuthRemoteService._internal();

  factory AuthRemoteService() {
    return _singleton;
  }

  AuthRemoteService._internal();

  final _storage = const FlutterSecureStorage();

  final StreamController<User?> _userDataController = new StreamController.broadcast();
  Stream<User?> get userDataStream => _userDataController.stream;

  void checkExistingUser() async {
    String? value = await _storage.read(key: AuthConstants.tokenStorageKey);
    if (value != null) {
      _userDataController.add(User(token: value));
    } else {
      _userDataController.add(null);
    }
  }

  Future<void> logOut() async {
    await _storage.delete(key: AuthConstants.tokenStorageKey);
    _userDataController.add(null);
  }

  Future<void> authUser(String username, String password) async {
    Map<String,dynamic> queryParams = {
      "username": username,
      "password": password
    };
    String uriString = NetworkConstants.apiUrl("/login");
    Response response = await Dio().post(uriString,
        queryParameters: queryParams,
        options: Options(headers: {
          "Content-Type": "application/json",
          'X-API-KEY': NetworkConstants.apiKey,
        }));

    debugPrint("[TEST] ${response.data.toString()}");

    Map responseBody = response.data;
    Map responseMap = responseBody as Map<String, dynamic>;

    String token = responseMap["token"] as String;

    _userDataController.add(User(token: token));

    _storage.write(key: AuthConstants.tokenStorageKey, value: token);
  }

  Future<void> registerUser(String username, String password) async {
    Map<String,dynamic> queryParams = {
      "username": username,
      "password": password
    };
    String uriString = NetworkConstants.apiUrl("/register");
    Response response = await Dio().post(uriString,
        queryParameters: queryParams,
        options: Options(headers: {
          "Content-Type": "application/json",
          'X-API-KEY': NetworkConstants.apiKey,
        }));

    debugPrint("[TEST] ${response.data.toString()}");

    return authUser(username, password);
  }
}