import 'dart:convert';

class OutPermit {
  final int? id;
  final String? userNik;
  final String? alasan;
  final String? date;
  final String? jamKeluar;
  final String? jamKembali;

  OutPermit({
    this.id = 0,
    this.userNik = '',
    this.alasan = '',
    this.date = '',
    this.jamKeluar = '',
    this.jamKembali = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userNik': userNik,
      'alasan': alasan,
      'date': date,
      'jamKeluar': jamKeluar,
      'jamKembali': jamKembali,
    };
  }

  factory OutPermit.fromMap(Map<String, dynamic> map) {
    return OutPermit(
      id: map['id']?.toInt(),
      userNik: map['userNik'],
      alasan: map['alasan'] ?? '-',
      date: map['date'],
      jamKeluar: map['jamKeluar'],
      jamKembali: map['jamKembali'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OutPermit.fromJson(String source) =>
      OutPermit.fromMap(json.decode(source));
}
