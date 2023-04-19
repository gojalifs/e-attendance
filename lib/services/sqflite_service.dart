import 'dart:io';

import 'package:e_presention/helper/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../data/models/user.dart';

class SqfLiteService {
  final DBHelper _dbHelper = DBHelper();

  Future saveUser(User user) async {
    final Database db = await _dbHelper.initDb();

    try {
      await db.insert('user', user.toMap());
    } on Exception {
      rethrow;
    }
  }

  Future updateUser(User user) async {
    final Database db = await _dbHelper.initDb();
    try {
      await db.update('user', user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getUser() async {
    final Database db = await _dbHelper.initDb();
    try {
      var data = await db.rawQuery('SELECT * FROM user');
      return User.fromMap(data.first);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkLoginStatus() async {
    final Database db = await _dbHelper.initDb();

    try {
      var result = await db.rawQuery('SELECT COUNT(*) FROM user');
      return result[0]['COUNT(*)'] == 1 ? true : false;
    } on FormatException {
      throw 'bad response';
    } on SocketException {
      throw 'check your network';
    } on HttpException {
      throw 'error on connecting';
    } catch (e) {
      rethrow;
    }
  }
}
