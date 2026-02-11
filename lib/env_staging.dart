import 'package:envied/envied.dart';

part 'env_staging.g.dart';

@Envied(path: '.env.staging')
abstract class EnvStaging {
  @EnviedField(varName: 'API_URL', obfuscate: true)
  static String apiUrl = _EnvStaging.apiUrl;

  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static String apiKey = _EnvStaging.apiKey;

  @EnviedField(varName: 'NOTIFICATION_API_URL', obfuscate: true)
  static String notificationApiUrl = _EnvStaging.notificationApiUrl;

  @EnviedField(varName: 'MQTT_BROKER_URL', obfuscate: true)
  static String mqttBrokerUrl = _EnvStaging.mqttBrokerUrl;

  @EnviedField(varName: 'MQTT_USERNAME', obfuscate: true)
  static String mqttUsername = _EnvStaging.mqttUsername;

  @EnviedField(varName: 'MQTT_PASSWORD', obfuscate: true)
  static String mqttPassword = _EnvStaging.mqttPassword;
}
