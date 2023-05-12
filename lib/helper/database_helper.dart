import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  Future initDb() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'epresensi.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nik TEXT,
            nama TEXT,
            nipns TEXT,
            email TEXT,
            gender TEXT,
            telp TEXT,
            isAdmin INTEGER,
            avaPath TEXT,
            token TEXT,
            tokenExpiry TEXT,
            createdAt TEXT,
            updatedAt TEXT,
            isLoggedIn INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE url (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            url TEXT
          )
        ''');
      },
    );
  }

  Future deleteDb() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'epresensi.db');
    deleteDatabase(path);
  }
}
