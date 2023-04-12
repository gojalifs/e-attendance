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
    await SqfLiteService().checkLoginStatus().then((value) {
      status = value;
    });
    if (status) {
      _user = await SqfLiteService().getUser();
      notifyListeners();
    }
    notifyListeners();
    return status;
  }

  Future logout() async {
    await _apiService.logout(user!.token!);
    await DBHelper().deleteDb();
    _user = User();
    notifyListeners();
  }
}
