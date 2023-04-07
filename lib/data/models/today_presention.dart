import 'dart:convert';

class TodayPresention {
  final int? id;
  final String? presentionId;
  final String? nik;
  final String? type;
  final String? time;

  TodayPresention({
    this.id = 0,
    this.presentionId = '',
    this.nik = '',
    this.type = '',
    this.time = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'presentionId': presentionId,
      'nik': nik,
      'type': type,
      'time': time,
    };
  }

  factory TodayPresention.fromMap(Map<String, dynamic> map) {
    return TodayPresention(
      id: map['id']?.toInt(),
      presentionId: map['presentionId'],
      nik: map['nik'],
      type: map['type'],
      time: map['time'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TodayPresention.fromJson(String source) =>
      TodayPresention.fromMap(json.decode(source));
}
