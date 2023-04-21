import 'dart:convert';

class PaidLeave {
  final int? id;
  final String? nik;
  final String? date;
  final String? endDate;
  final String? alasan;
  final String? potongCuti;
  PaidLeave({
    this.id,
    this.nik,
    this.date,
    this.endDate,
    this.alasan,
    this.potongCuti,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nik': nik,
      'date': date,
      'endDate': endDate,
      'alasan': alasan,
      'potong_cuti': potongCuti,
    };
  }

  factory PaidLeave.fromMap(Map<String, dynamic> map) {
    return PaidLeave(
      id: map['id']?.toInt(),
      nik: map['nik'],
      date: map['date'],
      endDate: map['endDate'],
      alasan: map['alasan'],
      potongCuti: map['potong_cuti'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PaidLeave.fromJson(String source) =>
      PaidLeave.fromMap(json.decode(source));
}
