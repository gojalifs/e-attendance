import 'package:e_presention/data/models/revision.dart';
import 'package:e_presention/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviseProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  ConnectionState _state = ConnectionState.none;
  List<Revisi> _revisis = [];

  ConnectionState get state => _state;
  List<Revisi> get revisi => _revisis;

  Future addRevise(DateTime date, TimeOfDay time, String reviseType,
      String reason, BuildContext context) async {
    String fDate = DateFormat('y-M-d').format(date);
    String fTime = time.format(context);

    _state = ConnectionState.active;
    notifyListeners();
    await _apiService.getUser();
    await _apiService.presentionRevise(fDate, fTime, reviseType, reason);
    _state = ConnectionState.done;
    notifyListeners();
  }

  Future fetchRevision() async {
    await _apiService.getUser();
    _revisis = await _apiService.fetchRevision();
    _state = ConnectionState.done;
    notifyListeners();
  }
}
