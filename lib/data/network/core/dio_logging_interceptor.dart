import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

final Logger apiLogger = Logger('API');

bool _apiLoggingEnabled = true;

void setApiLogging({bool enabled = true}) {
  _apiLoggingEnabled = enabled;
  apiLogger.level = enabled ? Level.ALL : Level.OFF;
  apiLogger.onRecord.listen((LogRecord record) {
    if (record.level >= Level.SEVERE) {
      developer.log(
        record.message,
        level: record.level.value,
        name: record.loggerName,
        error: record.error,
        stackTrace: record.stackTrace,
      );
    } else {
      _developerLog(record);
    }
  });
}

void _developerLog(LogRecord record) {
  developer.log(
    record.message,
    level: record.level.value,
    name: record.loggerName,
  );
}

class DioLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_apiLoggingEnabled) {
      apiLogger.info("""
[API_LOG] REQUEST:
Method: ${options.method}
URL: ${options.uri}
Headers: ${options.headers}
Body: ${options.data ?? 'null'}
""");
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_apiLoggingEnabled) {
      apiLogger.info("""
[API_LOG] RESPONSE:
Method: ${response.requestOptions.method}
URL: ${response.requestOptions.uri}
Status Code: ${response.statusCode}
Headers: ${response.headers}
Body: ${response.data}
""");
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_apiLoggingEnabled) {
      apiLogger.info("""
[API_LOG] ERROR:
Error Type: ${err.type}
URL: ${err.requestOptions.uri}
Status Code: ${err.response?.statusCode ?? 'Unknown'}
Request Data: ${err.requestOptions.data}
Response Body: ${err.response?.data ?? err.message}
""");
    }
    super.onError(err, handler);
  }
}
