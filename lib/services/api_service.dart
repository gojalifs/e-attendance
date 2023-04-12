import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:e_presention/env/env.dart';
import 'package:e_presention/services/sqflite_service.dart';

import '../data/models/presention.dart';
import '../data/models/today_presention.dart';
import '../data/models/user.dart';

class ApiService {
  final baseUrl = Env.URL;
  User user = User();

  Future getUser() async {
    user = await SqfLiteService().getUser();
  }

  Future<User> login(String id, String password) async {
    var endpoint = Uri.parse('$baseUrl/user/login');

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
        User user = User.fromMap(data);
        SqfLiteService().saveUser(user);

        return user;
      } else {
        throw 'invalid credential';
      }
    } catch (e) {
      throw 'failed login, $e';
    }
  }

  Future<List<Presention>> getPresention(String nik, String token) async {
    var endPoint = Uri.parse('$baseUrl/presen/$nik');

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

  Future<List<TodayPresention>> getTodayPresention(
      String nik, String token) async {
    var endPoint = Uri.parse('$baseUrl/daily');

    try {
      var resp = await http.post(
        endPoint,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {'nik': nik},
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

  Future<Map<String, dynamic>> uploadPresent(
      String type, String longitude, String latitude, File file) async {
    await getUser();
    var endPoint = Uri.parse('$baseUrl/presen');
    try {
      final request = http.MultipartRequest('POST', endPoint)
        ..fields['nik'] = user.nik!
        ..fields['jenis'] = type
        ..fields['longitude'] = longitude
        ..fields['latitude'] = latitude
        ..files.add(await http.MultipartFile.fromPath('img', file.path))
        ..headers['Accept'] = 'application/json'
        ..headers['Authorization'] = 'Bearer ${user.token}';

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

  Future logout(String token) async {
    var endpoint = Uri.parse('$baseUrl/logout');

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
