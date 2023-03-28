import 'dart:convert';

class User {
  final int id;
  final String name;
  final String nik;
  final String nip;
  final String email;
  final String gender;
  final String telp;
  final String isAdmin;

  User(this.id, this.name, this.nik, this.nip, this.email, this.gender,
      this.telp, this.isAdmin);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nik': nik,
      'nip': nip,
      'email': email,
      'gender': gender,
      'telp': telp,
      'isAdmin': isAdmin,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['id']?.toInt() ?? 0,
      map['name'] ?? '',
      map['nik'] ?? '',
      map['nip'] ?? '',
      map['email'] ?? '',
      map['gender'] ?? '',
      map['telp'] ?? '',
      map['isAdmin'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
