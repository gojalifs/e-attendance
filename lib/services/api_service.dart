import 'dart:convert';
import 'dart:io';

import 'package:e_presention/data/models/out_permit.dart';
import 'package:e_presention/data/models/paid_leave.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:e_presention/env/env.dart';
import 'package:e_presention/services/sqflite_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../data/models/presention.dart';
import '../data/models/revision.dart';
import '../data/models/today_presention.dart';
import '../data/models/user.dart';

class ApiService {
  final _baseUrl = Env.url;
  // final _baseUrl = url;
  User _user = User();
  String token = '';

  Map<String, String> _setHeader() {
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
  }

  Future getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    _user = await SqfLiteService().getUser();
    print('_user ${_user.toMap()}');
  }

  Future<User> login(String id, String password) async {
    var endpoint = Uri.parse('$_baseUrl/user/login');

    var resp = await http.post(endpoint, headers: {
      'Accept': 'application/json'
    }, body: {
      'nik': id,
      'password': password,
    });
    print(resp.statusCode);
    try {
      if (resp.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(resp.body)['data'];
        print(jsonDecode(resp.body));
        data['isLoggedIn'] = 1;
        _user = User.fromMap(data);
        print(_user.toMap());

        SqfLiteService().saveUser(_user);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', _user.token!);
        print('token $token');

        await getUser();
        return _user;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw 'failed login, $e';
    }
  }

  Future<bool> checkLoginStatus() async {
    try {
      await getUser();
    } catch (e) {
      rethrow;
    }
    var endPoint = Uri.parse('$_baseUrl/user/checkstatus');

    try {
      var resp = await http.post(
        endPoint,
        headers: _setHeader(),
      );
      print(resp.body);
      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on SocketException {
      throw 'Error when communicate with Server. Check your connection.';
    }
  }

  Future<List<Presention>> getPresention() async {
    var endPoint = Uri.parse('$_baseUrl/presen/${_user.nik}');

    try {
      var resp = await http.get(
        endPoint,
        headers: _setHeader(),
      );
      var data = jsonDecode(resp.body);
      List presList = data['data'];
      var result = presList.map((e) => Presention.fromMap(e)).toList();
      return result;
    } on FormatException {
      throw 'Bad Response';
    } on SocketException {
      throw 'Error on Network';
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TodayPresention>> getTodayPresention(String? date) async {
    await getUser();
    var endPoint = Uri.parse('$_baseUrl/daily');

    try {
      var resp = await http.post(
        endPoint,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
        body: {
          'nik': _user.nik,
          'date': date,
        },
      );
      var data = jsonDecode(resp.body);
      print(data);

      List result = data['data'];
      return result.map((e) => TodayPresention.fromMap(e)).toList();
    } on FormatException {
      throw 'Bad Response';
    } on SocketException {
      throw 'Error on Network';
    } catch (e) {
      rethrow;
    }
  }

  Future<int> presentionCount() async {
    await getUser();
    var endPoint = Uri.parse('$_baseUrl/dailycount');

    try {
      var resp = await http
          .post(endPoint, headers: _setHeader(), body: {'nik': _user.nik});
      var data = jsonDecode(resp.body);
      print('data $data');
      return data['data'];
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> uploadPresent(
      String type, String longitude, String latitude, File file) async {
    await getUser();
    var endPoint = Uri.parse('$_baseUrl/presen');
    try {
      final request = http.MultipartRequest('POST', endPoint)
        ..fields['nik'] = _user.nik!
        ..fields['jenis'] = type
        ..fields['longitude'] = longitude
        ..fields['latitude'] = latitude
        ..files.add(await http.MultipartFile.fromPath('img', file.path))
        ..headers['Accept'] = 'application/json'
        ..headers['Authorization'] = 'Bearer ${token}';

      var resp = await request.send();
      var respBody = await http.Response.fromStream(resp);

      if (respBody.statusCode == 401) {
        throw 'Unauthenticated';
      } else if (respBody.statusCode == 422 ||
          respBody.body.contains('Already')) {
        throw 'already check in/out';
      } else {
        Map<String, dynamic> data = jsonDecode(respBody.body);
        return data['data'][0];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getProfile() async {
    try {
      print('token $token');
      await getUser();
      String nik = _user.nik ?? '';

      var endPoint = Uri.parse('$_baseUrl/user/data/$nik');
      var resp = await http.get(endPoint, headers: _setHeader());
      Map<String, dynamic> result = jsonDecode(resp.body);
      print(result);
      User user = User.fromMap(result);
      SqfLiteService().updateUser(user);
      return user;
    } on SocketException {
      throw 'Error on Network';
    } on FormatException {
      throw 'Bad Response';
    } catch (e) {
      rethrow;
    }
  }

  Future<User> updateProfile(String column, String? data) async {
    var endPoint = Uri.parse('$_baseUrl/updateuser');

    try {
      var resp = await http.post(endPoint, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}',
      }, body: {
        'nik': _user.nik,
        'column': column,
        'data': data,
      });

      Map<String, dynamic> result = jsonDecode(resp.body);
      User user = User.fromMap(result['data']);
      print(user);
      SqfLiteService().updateUser(user);
      return user;
    } on FormatException {
      throw 'Bad Response';
    } on SocketException {
      throw 'Error on Network';
    } catch (e) {
      rethrow;
    }
  }

  Future<User> updateAvatar(File img) async {
    var endPoint = Uri.parse('$_baseUrl/updateava');

    try {
      final request = http.MultipartRequest('POST', endPoint)
        ..fields['nik'] = _user.nik!
        ..files.add(await http.MultipartFile.fromPath('img', img.path))
        ..headers['Accept'] = 'application/json'
        ..headers['Authorization'] = 'Bearer ${token}';

      var resp = await request.send();
      var respBody = await http.Response.fromStream(resp);
      print(respBody.body);
      Map<String, dynamic> result = jsonDecode(respBody.body);
      _user = User.fromMap(result['data']);
      await SqfLiteService().updateUser(_user);
      return _user;
    } on FormatException {
      throw 'Bad Response';
    } on SocketException {
      throw 'Error on Network';
    } catch (e) {
      rethrow;
    }
  }

  /// IZIN SECTION
  ///

  Future addPermit(
    String date,
    TimeOfDay outTime,
    TimeOfDay backTime,
    String reason,
  ) async {
    String formattedOutTime = '${outTime.hour}:${outTime.minute}';
    String formattedbackTime = '${backTime.hour}:${backTime.minute}';

    var endPoint = Uri.parse('$_baseUrl/izink');

    try {
      var resp = await http.post(endPoint, headers: _setHeader(), body: {
        'tanggal': date,
        'user_nik': _user.nik,
        'alasan': reason,
        'jam_keluar': formattedOutTime,
        'jam_kembali': formattedbackTime,
      });

      var data = jsonDecode(resp.body);
      var result = data['data'];
      return result;
    } on FormatException {
      throw 'Bad Response';
    } on SocketException {
      throw 'Error on Network';
    } catch (e) {
      rethrow;
    }
  }

  Future<List<OutPermit>> fetchpermit() async {
    await getUser();
    var endPoint = Uri.parse('$_baseUrl/izink/${_user.nik}');

    var resp = await http.get(endPoint, headers: _setHeader());
    Map<String, dynamic> data = jsonDecode(resp.body);
    List list = data['data'];
    List<OutPermit> result = list.map((e) => OutPermit.fromMap(e)).toList();
    return result;
  }

  /* 
    LEAVES SECTION

  */

  Future addLeave(
    DateTime date,
    DateTime? endDate,
    bool isPaidLeave,
    String reason,
    String type,
  ) async {
    String formattedDate = DateFormat('y-M-d').format(date);
    String formattedEndDate = '';
    if (endDate != null) {
      formattedEndDate = DateFormat('y-M-d').format(endDate);
    } else {
      formattedEndDate = formattedDate;
    }

    var endPoint = Uri.parse('$_baseUrl/absen');

    try {
      var resp = await http.post(endPoint, headers: _setHeader(), body: {
        'nik': _user.nik,
        'tanggal': formattedDate,
        'tanggal_selesai': formattedEndDate,
        'alasan': reason,
        'jenis_cuti': type,
        'potong_cuti': isPaidLeave ? 'ya' : 'tidak'
      });
      var data = jsonDecode(resp.body);
      var result = data['data'];
      return result;
    } on FormatException {
      throw 'Bad Response';
    } on SocketException {
      throw 'Error on Network';
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PaidLeave>> fetchLeave() async {
    await getUser();
    var endPoint = Uri.parse('$_baseUrl/absen/${_user.nik}');

    var resp = await http.get(endPoint, headers: _setHeader());
    Map<String, dynamic> data = jsonDecode(resp.body);
    print(data);
    List list = data['data'];
    List<PaidLeave> result = list.map((e) => PaidLeave.fromMap(e)).toList();
    return result;
  }

  Future presentionRevise(
    String date,
    String time,
    String revised,
    String reason,
    File image,
  ) async {
    var endPoint = Uri.parse('$_baseUrl/revisi');

    try {
      final request = http.MultipartRequest('POST', endPoint)
        ..fields['user_nik'] = _user.nik!
        ..fields['tanggal'] = date
        ..fields['jam'] = time
        ..fields['yang_direvisi'] = revised
        ..files.add(await http.MultipartFile.fromPath('img', image.path))
        ..fields['alasan'] = reason
        ..headers['Accept'] = 'application/json'
        ..headers['Authorization'] = 'Bearer ${token}';

      var resp = await request.send();
      var respBody = await http.Response.fromStream(resp);

      print('respbody ${request.fields}');

      if (respBody.statusCode == 401) {
        throw 'Unauthenticated';
      } else if (respBody.statusCode == 200 || respBody.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(respBody.body);
        print(data['data']);
        return data['data'];
      } else {
        throw 'Something error';
      }
    } catch (e) {}
    var resp = await http.post(endPoint, headers: _setHeader(), body: {
      'user_nik': _user.nik,
      'tanggal': date,
      'jam': time,
      'yang_direvisi': revised,
      'alasan': reason,
    });
    Map<String, dynamic> data = jsonDecode(resp.body);
    var result = data['data'];
    return result;
  }

  Future<List<Revisi>> fetchRevision() async {
    await getUser();
    var endPoint = Uri.parse('$_baseUrl/revisi/${_user.nik}');

    var resp = await http.get(endPoint, headers: _setHeader());
    Map<String, dynamic> data = jsonDecode(resp.body);
    print(data);
    List list = data['data'];
    List<Revisi> result = list.map((e) => Revisi.fromMap(e)).toList();
    return result;
  }

  Future logout(String token) async {
    var endpoint = Uri.parse('$_baseUrl/logout');

    try {
      var resp = await http.get(
        endpoint,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print(resp.body);
      if (resp.statusCode == 500 || resp.statusCode == 401) {
        throw Exception('unauthorized');
      }
    } on FormatException {
      throw 'Bad Response';
    }
  }
}
