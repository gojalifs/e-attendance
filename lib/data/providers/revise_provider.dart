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
    String fTime = time.format(context);

    _state = ConnectionState.active;
    notifyListeners();
    await _apiService.getUser();
    await _apiService.presentionRevise(
        fDate, fTime, reviseType, reason, _image!);
    _state = ConnectionState.done;
    notifyListeners();
  }

  Future fetchRevision() async {
    await _apiService.getUser();
    _revisis = await _apiService.fetchRevision();
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
