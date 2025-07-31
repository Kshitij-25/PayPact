abstract class ActivityException implements Exception {
  final String message;
  const ActivityException(this.message);
}

class ActivityLogException extends ActivityException {
  const ActivityLogException() : super('Failed to log activity');
}

class ActivityNotFoundException extends ActivityException {
  const ActivityNotFoundException() : super('Activity not found');
}
