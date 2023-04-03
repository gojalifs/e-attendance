import 'package:e_presention/services/api_service.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;

  User? get user => _user;

  Future login(String id, String password) async {
    _user = await _apiService.login(id, password);
    notifyListeners();
  }

  Future logout() async {
    await _apiService.logout(user!.token!);
    _user = null;
    notifyListeners();
  }
}
