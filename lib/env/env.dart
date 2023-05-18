// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'url', obfuscate: true)
  // static final url = _Env.url;
  static const url = 'http://192.168.81.22:81/api';

  @EnviedField(varName: 'imageUrl', obfuscate: true)
  // static final imageUrl = _Env.imageUrl;
  static const imageUrl = 'http://192.168.81.22:81/storage';
}
