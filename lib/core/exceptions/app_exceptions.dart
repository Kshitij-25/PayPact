abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when there's no internet or timeout
class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}

/// Thrown when Firebase Auth or API returns unauthorized
class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized access']);
}

/// Thrown for general server-side errors
class ServerException extends AppException {
  const ServerException([super.message = 'Something went wrong']);
}

/// Thrown when a requested item is not found (404-like)
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found']);
}

/// Thrown for user input validation or logical errors
class ValidationException extends AppException {
  const ValidationException([super.message = 'Invalid input']);
}

/// Fallback for unknown/unexpected errors
class UnknownException extends AppException {
  const UnknownException([super.message = 'Unexpected error occurred']);
}
