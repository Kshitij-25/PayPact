import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class AppLogger {
  static void logInfo(String message, {String tag = 'INFO'}) {
    if (kDebugMode) {
      developer.log(message, name: tag);
    }
  }

  static void logWarning(String message, {String tag = 'WARNING'}) {
    developer.log(message, name: tag, level: 900);
  }

  static void logError(
    String message, {
    String tag = 'ERROR',
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void logDebug(String message, {String tag = 'DEBUG'}) {
    if (kDebugMode) {
      developer.log(message, name: tag);
    }
  }

  static void logEvent(String name, {Map<String, dynamic>? params}) {
    // For Firebase or analytics integrations
    logInfo('Event: $name, Params: $params', tag: 'EVENT');
  }
}
