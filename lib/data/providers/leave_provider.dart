import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../models/paid_leave.dart';

class LeaveProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  ConnectionState _connectionState = ConnectionState.none;
  List<PaidLeave> _leave = [];

  ConnectionState get connectionState => _connectionState;
  List<PaidLeave> get leave => _leave;

  Future uploadCreateLeave(DateTime date, DateTime endDate, bool isPaidLeave,
      String reason, String type) async {
    _connectionState = ConnectionState.active;
    await _apiService.addLeave(date, endDate, isPaidLeave, reason, type);
    _connectionState = ConnectionState.done;
    notifyListeners();
  }

  Future fetchLeave() async {
    _connectionState = ConnectionState.active;
    await _apiService.getUser();
    _leave = await _apiService.fetchLeave();
    _connectionState = ConnectionState.done;
    notifyListeners();
  }
}
