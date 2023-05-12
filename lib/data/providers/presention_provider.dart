import 'package:flutter/material.dart';

import 'package:e_presention/data/models/presention.dart';
import 'package:e_presention/data/models/today_presention.dart';
import 'package:e_presention/services/api_service.dart';
import 'package:intl/intl.dart';

class PresentProvider with ChangeNotifier {
  static final ApiService apiService = ApiService();
  List<Presention> _presention = [];
  ConnectionState _state = ConnectionState.none;
  List<TodayPresention> _today = [TodayPresention(), TodayPresention()];
  List<TodayPresention> _todayReports = [TodayPresention(), TodayPresention()];
  int _count = 0;

  List<Presention> get presention => _presention;
  ConnectionState get state => _state;
  List<TodayPresention> get today => _today;
  List<TodayPresention> get todayReports => _todayReports;
  int get count => _count;

  Future getPresention(String nik, String token) async {
    _state = ConnectionState.active;
    _presention = await apiService.getPresention();
    _state = ConnectionState.done;
    notifyListeners();
  }

  Future getTodayPresention(DateTime formattedDate) async {
    _state = ConnectionState.active;
    String fDate = DateFormat('y-M-d').format(formattedDate);
    _today = await apiService.getTodayPresention(fDate);
    _state = ConnectionState.done;
    notifyListeners();
  }

  Future getTodayReportPresention(DateTime formattedDate) async {
    _state = ConnectionState.active;
    String fDate = DateFormat('y-M-d').format(formattedDate);
    _todayReports = await apiService.getTodayPresention(fDate);
    _state = ConnectionState.done;
    notifyListeners();
  }

  Future presentionCount() async {
    _state = ConnectionState.active;
    await apiService.getUser();
    _count = await apiService.presentionCount();
    _state = ConnectionState.done;
    notifyListeners();
  }
}
