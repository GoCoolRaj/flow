import 'package:envied/envied.dart';

part 'env_prod.g.dart';

@Envied(path: '.env.prod')
abstract class EnvProd {
  @EnviedField(varName: 'API_URL', obfuscate: true)
  static String apiUrl = _EnvProd.apiUrl;

  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static String apiKey = _EnvProd.apiKey;
}
