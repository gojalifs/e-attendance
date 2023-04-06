import 'dart:convert';

import 'package:e_presention/data/models/user.dart';
import 'package:e_presention/env/env.dart';
import 'package:e_presention/services/sqflite_service.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final baseUrl = Env.URL;

  Future<User> getUser(String id) async {
    var endpoint = Uri.parse('$baseUrl/users/getuser.php?id=$id');
    var data = await http.get(endpoint);
    var resp = jsonDecode(data.body);
    return User.fromMap(resp);
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
        print(data);
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
      print('${resp.body}');
      print(' ${resp.statusCode}');
      if (resp.statusCode == 500 || resp.statusCode == 401) {
        throw Exception('unauthorized');
      }
    } on FormatException {
      throw 'Bad Response';
    }
  }
}
