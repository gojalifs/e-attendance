import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/api_service.dart';
import '../models/today_presention.dart';

class ReportProvider extends ChangeNotifier {
  static final ApiService apiService = ApiService();
  ConnectionState _state = ConnectionState.none;
  List<TodayPresention> _today = [];

  ConnectionState get state => _state;
  List<TodayPresention> get today => _today;

  Future getTodayPresention(DateTime date) async {
    _state = ConnectionState.active;
    String fDate = DateFormat('y-M-d').format(date);
    _today = await apiService.getTodayPresention(fDate).whenComplete(() {
      _state = ConnectionState.done;
    });
    _state = ConnectionState.done;
    notifyListeners();
  }
}
