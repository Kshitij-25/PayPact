class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message; // Add this line
}

class NotAuthenticatedException extends AuthException {
  const NotAuthenticatedException() : super('User not authenticated');
}

class CancelledByUserException extends AuthException {
  const CancelledByUserException() : super('Operation cancelled by user');
}

class AccountExistsException extends AuthException {
  const AccountExistsException() : super('Account already exists with different credentials');
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException() : super('Invalid credentials');
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException() : super('Password is too weak');
}

class EmailInUseException extends AuthException {
  const EmailInUseException() : super('Email already in use');
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException() : super('User not found');
}

class WrongPasswordException extends AuthException {
  const WrongPasswordException() : super('Wrong password');
}

class TooManyRequestsException extends AuthException {
  const TooManyRequestsException() : super('Too many requests. Try again later');
}
