import 'dart:convert';

import 'package:e_presention/data/models/user.dart';
import 'package:e_presention/env/env.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final baseUrl = Env.url;

  Future<User> getUser(String id) async {
    var endpoint = Uri.parse('$baseUrl/users/getuser.php?id=$id');
    var data = await http.get(endpoint);
    var resp = jsonDecode(data.body);
    return User.fromMap(resp);
  }
}
