// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  /// TODO make change when hosted online and edit gitignore
  @EnviedField(varName: 'url', obfuscate: true)
  // static final url = _Env.url;
  static const url = 'https://ba7a-2404-c0-2020-00-cc-e996.ngrok-free.app/api';

  @EnviedField(varName: 'imageUrl', obfuscate: true)
  // static final imageUrl = _Env.imageUrl;
  static const imageUrl =
      'https://ba7a-2404-c0-2020-00-cc-e996.ngrok-free.app/storage';
}
