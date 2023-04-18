import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:e_presention/env/env.dart';
import 'package:e_presention/services/sqflite_service.dart';
import 'package:intl/intl.dart';

import '../data/models/presention.dart';
import '../data/models/today_presention.dart';
import '../data/models/user.dart';

class ApiService {
  final _baseUrl = Env.URL;
  User _user = User();

  Map<String, String> setHeader() {
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_user.token}',
    };
  }

  Future getUser() async {
    _user = await SqfLiteService().getUser();
  }

  Future<User> login(String id, String password) async {
    var endpoint = Uri.parse('$_baseUrl/user/login');

    var resp = await http.post(endpoint, headers: {
      'Accept': 'application/json'
    }, body: {
      'nik': id,
      'password': password,
    });

    try {
      if (resp.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(resp.body)['data'];
        data['isLoggedIn'] = 1;
        _user = User.fromMap(data);

        SqfLiteService().saveUser(_user);
        await getUser();
        return _user;
      } else {
        throw 'invalid credential';
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

    var resp = await http.post(
      endPoint,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_user.token}',
      },
    );
    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Presention>> getPresention(String nik, String token) async {
    var endPoint = Uri.parse('$_baseUrl/presen/$nik');

    try {
      var resp = await http.get(endPoint, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
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

  Future<List<TodayPresention>> getTodayPresention() async {
    await getUser();
    var endPoint = Uri.parse('$_baseUrl/daily');
    String date = DateFormat('y-M-d', 'id-ID').format(DateTime.now());

    try {
      var resp = await http.post(
        endPoint,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${_user.token}',
        },
        body: {
          'nik': _user.nik,
          'date': date,
        },
      );
      var data = jsonDecode(resp.body);

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
    var endPoint = Uri.parse('$_baseUrl/dailycount');

    try {
      var resp = await http
          .post(endPoint, headers: setHeader(), body: {'nik': _user.nik});
      var data = jsonDecode(resp.body);
      print(data);
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
        ..headers['Authorization'] = 'Bearer ${_user.token}';

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

  Future<User> updateProfile(String column, String? data) async {
    var endPoint = Uri.parse('$_baseUrl/updateuser');

    try {
      var resp = await http.post(endPoint, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_user.token}',
      }, body: {
        'nik': _user.nik,
        'column': column,
        'data': data,
      });

      Map<String, dynamic> result = jsonDecode(resp.body);
      return User.fromMap(result['data']);
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
        ..headers['Authorization'] = 'Bearer ${_user.token}';

      var resp = await request.send();
      var respBody = await http.Response.fromStream(resp);

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
      if (resp.statusCode == 500 || resp.statusCode == 401) {
        throw Exception('unauthorized');
      }
    } on FormatException {
      throw 'Bad Response';
    }
  }
}
