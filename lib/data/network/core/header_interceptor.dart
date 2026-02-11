import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/app/environment.dart';
import 'package:quilt_flow_app/app/helpers/extensions/string_extensions.dart';
import 'package:quilt_flow_app/data/local/hive_manager.dart';

class HeaderInterceptor extends Interceptor {
  final String _quiltApiKey = EnvironmentConfig.quiltApiKey;
  final HiveManager _hiveManager = GetIt.I<HiveManager>();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? userToken = _hiveManager.getFromHive(
      HiveManager.userSessionTokenKey,
    );

    final authToken = userToken.isNullOrEmpty ? _quiltApiKey : userToken;
    options.headers['Authorization'] = 'Bearer $authToken';

    super.onRequest(options, handler);
  }
}
