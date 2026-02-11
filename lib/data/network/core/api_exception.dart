class ApiException implements Exception {
  final int? errorCode;
  final String? message;
  final String? errorMessage;

  const ApiException({this.message, this.errorCode, this.errorMessage});

  @override
  String toString() => 'ApiException(message: $message, errorCode: $errorCode)';
}

class UnknownServiceException extends ApiException {
  const UnknownServiceException({super.message});
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({super.message});
}

class BadResponseException extends ApiException {
  const BadResponseException({super.message});
}

class ModerationException extends ApiException {
  const ModerationException({super.message});
}

extension ApiExceptionErrorCodes on ApiException {}
