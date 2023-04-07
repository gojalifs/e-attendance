import 'dart:convert';

class User {
  final int? id;
  final String? nik;
  final String? nama;
  final String? nipns;
  final String? email;
  final String? gender;
  final String? telp;
  final int? isAdmin;
  final String? avaPath;
  final String? token;
  final String? tokenExpiry;
  final String? createdAt;
  final String? updatedAt;
  int? isLoggedIn;

  User({
    this.id = 0,
    this.nik = '',
    this.nama = '',
    this.nipns = '',
    this.email = '',
    this.gender = '',
    this.telp = '',
    this.isAdmin = 0,
    this.avaPath = '',
    this.token = '',
    this.tokenExpiry = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.isLoggedIn = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nik': nik,
      'nama': nama,
      'nipns': nipns,
      'email': email,
      'gender': gender,
      'telp': telp,
      'isAdmin': isAdmin,
      'avaPath': avaPath,
      'token': token,
      'tokenExpiry': tokenExpiry,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isLoggedIn': isLoggedIn,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt(),
      nik: map['nik'],
      nama: map['nama'],
      nipns: map['nipns'],
      email: map['email'],
      gender: map['gender'],
      telp: map['telp'],
      isAdmin: map['isAdmin']?.toInt(),
      avaPath: map['avaPath'],
      token: map['token'],
      tokenExpiry: map['tokenExpiry'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      isLoggedIn: map['isLoggedIn']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
