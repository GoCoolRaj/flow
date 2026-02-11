import 'package:envied/envied.dart';

part 'env_demo.g.dart';

@Envied(path: '.env.demo')
abstract class EnvDemo {
  @EnviedField(varName: 'API_URL', obfuscate: true)
  static String apiUrl = _EnvDemo.apiUrl;
}
