import 'dart:convert';

class Presention {
  final int? id;
  final String? idPresensi;
  final String? date;
  final List<PresentionDetail>? details;

  Presention({
    this.id = 0,
    this.idPresensi = '',
    this.date = '',
    this.details,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idPresensi': idPresensi,
      'date': date,
      'details': details?.map((x) => x.toMap()).toList(),
    };
  }

  factory Presention.fromMap(Map<String, dynamic> map) {
    return Presention(
      id: map['id']?.toInt(),
      idPresensi: map['idPresensi'],
      date: map['date'],
      details: map['details'] != null
          ? List<PresentionDetail>.from(
              map['details']?.map((x) => PresentionDetail.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Presention.fromJson(String source) =>
      Presention.fromMap(json.decode(source));
}

class PresentionDetail {
  final String? type;
  final String? time;
  final String? longitude;
  final String? latitude;
  final String? imgPath;
  PresentionDetail({
    this.type = '',
    this.time = '',
    this.longitude = '',
    this.latitude = '',
    this.imgPath = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'time': time,
      'longitude': longitude,
      'latitude': latitude,
      'imgPath': imgPath,
    };
  }

  factory PresentionDetail.fromMap(Map<String, dynamic> map) {
    return PresentionDetail(
      type: map['type'],
      time: map['time'],
      longitude: map['longitude'],
      latitude: map['latitude'],
      imgPath: map['imgPath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PresentionDetail.fromJson(String source) =>
      PresentionDetail.fromMap(json.decode(source));
}
