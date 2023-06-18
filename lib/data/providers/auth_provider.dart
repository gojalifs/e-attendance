import 'dart:io';

import 'package:flutter/material.dart';

import '../../helper/database_helper.dart';
import '../../services/api_service.dart';
import '../../services/sqflite_service.dart';
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

    status = await _apiService.checkLoginStatus().whenComplete(() {
      _connectionState = ConnectionState.done;
    });

    if (status) {
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

  Future getProfile() async {
    _connectionState = ConnectionState.active;

    _user = await _apiService.getProfile().whenComplete(() {
      _connectionState = ConnectionState.done;
    });
    _connectionState = ConnectionState.done;
    notifyListeners();
  }

  Future updateProfile(String column, String data) async {
    _connectionState = ConnectionState.active;

    _user = await _apiService.updateProfile(column, data).whenComplete(() {
      _connectionState = ConnectionState.done;
    });

    _connectionState = ConnectionState.done;
    notifyListeners();
  }

  Future updateAvatar(File img) async {
    _connectionState = ConnectionState.active;
    _user = await _apiService.updateAvatar(img).whenComplete(() {
      _connectionState = ConnectionState.done;
    });
    _connectionState = ConnectionState.done;
    notifyListeners();
  }

  Future logout() async {
    _connectionState = ConnectionState.active;
    await _apiService.logout().whenComplete(() {
      _connectionState = ConnectionState.done;
    });
    await DBHelper().deleteDb();
    _user = User();
    _connectionState = ConnectionState.done;
    notifyListeners();
  }
}
