import 'package:flutter/material.dart';

import 'package:e_presention/data/models/presention.dart';
import 'package:e_presention/data/models/today_presention.dart';
import 'package:e_presention/services/api_service.dart';

class PresentProvider with ChangeNotifier {
  final ApiService apiService = ApiService();
  List<Presention> _presention = [];
  ConnectionState _state = ConnectionState.none;
  List<TodayPresention> _today = [TodayPresention(), TodayPresention()];

  List<Presention> get presention => _presention;
  ConnectionState get state => _state;
  List<TodayPresention> get today => _today;

  Future getPresention(String nik, String token) async {
    _state = ConnectionState.active;
    _presention = await apiService.getPresention(nik, token);
    _state = ConnectionState.done;
    notifyListeners();
  }

  Future getTodayPresention(String nik, String token) async {
    _state = ConnectionState.active;
    _today = await apiService.getTodayPresention(nik, token);
    _state = ConnectionState.done;
    notifyListeners();
  }
}
