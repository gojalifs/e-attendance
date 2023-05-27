import 'package:e_presention/data/models/out_permit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/api_service.dart';

class ExitPermitProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  ConnectionState _connectionState = ConnectionState.none;
  List<OutPermit> _permit = [];

  ConnectionState get connectionState => _connectionState;
  List<OutPermit> get permit => _permit;

  Future uploadCreatePermit(DateTime date, TimeOfDay outTime,
      TimeOfDay backTime, String reason) async {
    String fDate = DateFormat('y-M-d').format(date);
    _connectionState = ConnectionState.active;
    await _apiService
        .addPermit(fDate, outTime, backTime, reason)
        .whenComplete(() {
      _connectionState = ConnectionState.done;
    });
    _connectionState = ConnectionState.done;
    notifyListeners();
  }

  Future fetchPermit() async {
    _connectionState = ConnectionState.active;
    _permit = await _apiService.fetchpermit().whenComplete(() {
      _connectionState = ConnectionState.done;
    });
    _connectionState = ConnectionState.done;
    notifyListeners();
  }
}
