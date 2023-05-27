import 'dart:convert';

class Revisi {
  final int? id;
  final String? nik;
  final String? date;
  final String? time;
  final String? reason;
  final String? revised;
  final int? isApproved;
  final String? approval;

  Revisi({
    this.id,
    this.nik,
    this.date,
    this.time,
    this.reason,
    this.revised,
    this.isApproved,
    this.approval,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nik': nik,
      'date': date,
      'time': time,
      'reason': reason,
      'revised': revised,
      'isApproved': isApproved,
      'approval': approval,
    };
  }

  factory Revisi.fromMap(Map<String, dynamic> map) {
    return Revisi(
      id: map['id']?.toInt(),
      nik: map['nik'],
      date: map['date'],
      time: map['time'],
      reason: map['reason'],
      revised: map['revised'],
      isApproved: map['isApproved']?.toInt(),
      approval: map['approval'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Revisi.fromJson(String source) => Revisi.fromMap(json.decode(source));
}
