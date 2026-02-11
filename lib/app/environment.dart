import 'package:quilt_flow_app/env_demo.dart';
import 'package:quilt_flow_app/env_prod.dart';
import 'package:quilt_flow_app/env_staging.dart';

class EnvironmentConfig {
  static const String flavor = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'prod',
  );

  static String get quiltApiUrl {
    if (flavor == 'demo') return EnvDemo.apiUrl;
    if (flavor == 'staging') return EnvStaging.apiUrl;
    if (flavor == 'prod') return EnvProd.apiUrl;
    return '';
  }

  static String get quiltNotificationApiUrl {
    if (flavor == 'staging') return EnvStaging.notificationApiUrl;

    return '';
  }

  static String get quiltApiKey {
    if (flavor == 'staging') return EnvStaging.apiKey;
    if (flavor == 'prod') return EnvProd.apiKey;

    return '';
  }

  static String get mqttBrokerUrl {
    if (flavor == 'staging') return EnvStaging.mqttBrokerUrl;

    return '';
  }

  static String get mqttUsername {
    if (flavor == 'staging') return EnvStaging.mqttUsername;

    return '';
  }

  static String get mqttPassword {
    if (flavor == 'staging') return EnvStaging.mqttPassword;

    return '';
  }
}
