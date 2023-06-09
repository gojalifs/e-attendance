import 'dart:io';

import 'package:e_presention/data/models/revision.dart';
import 'package:e_presention/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ReviseProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final ImagePicker picker = ImagePicker();
  ConnectionState _state = ConnectionState.none;
  List<Revisi> _revisis = [];
  File? _image;

  ConnectionState get state => _state;
  List<Revisi> get revisi => _revisis;
  File? get images => _image;

  Future addRevise(DateTime date, TimeOfDay time, String reviseType,
      String reason, BuildContext context) async {
    String fDate = DateFormat('y-M-d').format(date);
    var fTime = DateFormat('HH:mm').parse(time.format(context));
    final formattedTime24 = DateFormat('hh:mm:ss').format(fTime);

    _state = ConnectionState.active;
    notifyListeners();
    await _apiService
        .presentionRevise(fDate, formattedTime24, reviseType, reason, _image!)
        .whenComplete(() {
      _state = ConnectionState.done;
      _image = null;
    });
    _state = ConnectionState.done;
    notifyListeners();
  }

  Future fetchRevision() async {
    _revisis = await _apiService.fetchRevision().whenComplete(() {
      _state = ConnectionState.done;
    });
    _state = ConnectionState.done;
    notifyListeners();
  }

  Future getPictCamera() async {
    final pict = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    var filePath = pict!.path;
    var targetPath = '${filePath}_compressed.jpg';
    File? compressed = await FlutterImageCompress.compressAndGetFile(
      filePath,
      targetPath,
      quality: 25,
    );

    _image = File(compressed!.path);
    notifyListeners();
  }

  Future getPictGallery() async {
    final pict = await picker.pickImage(
      source: ImageSource.gallery,
    );
    var filePath = pict!.path;
    var targetPath = '${filePath}_compressed.jpg';
    File? compressed = await FlutterImageCompress.compressAndGetFile(
      filePath,
      targetPath,
      quality: 25,
    );

    _image = File(compressed!.path);
    notifyListeners();
  }

  removeImage() {
    _image = null;
  }
}
