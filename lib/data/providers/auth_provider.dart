import 'dart:io';

import 'package:e_presention/services/sqflite_service.dart';
import 'package:flutter/material.dart';

import 'package:e_presention/helper/database_helper.dart';
import 'package:e_presention/services/api_service.dart';

import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  ConnectionState _connectionState = ConnectionState.none;
  User? _user = User();

  User? get user => _user;
  ConnectionState get connectionState => _connectionState;

  Future login(String id, String password) async {
    _connectionState = ConnectionState.active;
    notifyListeners();

    _user = await _apiService.login(id, password).whenComplete(() {
      _connectionState = ConnectionState.done;
      notifyListeners();
    });
    _user!.isLoggedIn = 1;

    notifyListeners();
  }

  Future<bool> checkLoginStatus() async {
    bool status = false;

    status = await _apiService.checkLoginStatus();

    if (status) {
      await _apiService.getUser();
      _user = await SqfLiteService().getUser();
      notifyListeners();
    } else {
      await DBHelper().deleteDb();
    }
    notifyListeners();
    return status;
  }

  /*
    TODO
    future development must move this code to user provider
  */
  Future updateProfile(String column, String data) async {
    _connectionState = ConnectionState.active;

    _user = await _apiService.updateProfile(column, data);

    _connectionState = ConnectionState.done;
    notifyListeners();
  }

  Future updateAvatar(File img) async {
    _connectionState = ConnectionState.active;
    _user = await _apiService.updateAvatar(img);
    _connectionState = ConnectionState.done;
    notifyListeners();
  }

  Future logout() async {
    _connectionState = ConnectionState.active;
    await _apiService.logout(user!.token!);
    await DBHelper().deleteDb();
    _user = User();
    _connectionState = ConnectionState.done;
    notifyListeners();
  }
}
