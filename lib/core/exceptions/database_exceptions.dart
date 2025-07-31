abstract class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);
}

class DataNotFoundException extends DatabaseException {
  const DataNotFoundException() : super('Requested data not found');
}

class DataConflictException extends DatabaseException {
  const DataConflictException() : super('Data conflict occurred');
}

class TransactionException extends DatabaseException {
  const TransactionException() : super('Transaction failed');
}

class QueryException extends DatabaseException {
  const QueryException() : super('Invalid query');
}
