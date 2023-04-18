import 'package:e_presention/data/models/presention.dart';
import 'package:e_presention/data/models/today_presention.dart';
import 'package:e_presention/services/api_service.dart';
import 'package:flutter/material.dart';

class ReportProvider extends ChangeNotifier {
  static final ApiService apiService = ApiService();
  ConnectionState _state = ConnectionState.none;
  List<TodayPresention> _today = [];

  ConnectionState get state => _state;
  List<TodayPresention> get today => _today;

  Future getTodayPresention(String? date) async {
    _state = ConnectionState.active;
    _today = await apiService.getTodayPresention(date);
    print('today $_today');
    _state = ConnectionState.done;
    notifyListeners();
  }
}
