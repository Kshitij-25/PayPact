abstract class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}

class NoInternetException extends NetworkException {
  const NoInternetException() : super('No internet connection');
}

class ServerException extends NetworkException {
  const ServerException() : super('Server error occurred');
}

class TimeoutException extends NetworkException {
  const TimeoutException() : super('Request timed out');
}
