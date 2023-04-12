import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:e_presention/data/models/presention.dart';
import 'package:e_presention/services/api_service.dart';

class PhotoProvider extends ChangeNotifier {
  ConnectionState _state = ConnectionState.none;
  final ApiService apiService = ApiService();
  final ImagePicker picker = ImagePicker();
  PresentionDetail _detail = PresentionDetail();
  LocationPermission _permission = LocationPermission.whileInUse;
  PermissionStatus _status = PermissionStatus.limited;
  String _long = '';
  String _lat = '';
  File? _image;

  ConnectionState get state => _state;
  PresentionDetail get presentionDetail => _detail;
  File? get images => _image;
  String get long => _long;
  String get lat => _lat;
  LocationPermission get permission => _permission;
  PermissionStatus get status => _status;

  Future getPict() async {
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

  Future getLocation() async {
    bool isGpsEnabled;
    LocationAccuracyStatus accuracy;
    Position location;

    isGpsEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isGpsEnabled) {
      return Future.error('Location are Disabled.');
    }
    _permission = await Geolocator.checkPermission();
    _status = await Permission.location.request();
    notifyListeners();
    accuracy = await Geolocator.getLocationAccuracy();

    if (accuracy == LocationAccuracyStatus.reduced) {
      await Geolocator.requestPermission();
    }
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        return Future.error('Location Permission is Denied');
      }
    }

    if (_permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    _long = '${location.longitude}';
    _lat = '${location.latitude}';
    notifyListeners();
    return await Geolocator.getCurrentPosition();
  }

  Future sendPresention(type) async {
    _state = ConnectionState.waiting;
    Map<String, dynamic> resp =
        await apiService.uploadPresent(type, long, lat, _image!);
    _detail = PresentionDetail.fromMap(resp);
    _state = ConnectionState.done;

    notifyListeners();
  }
}
