import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'activity_exceptions.dart';
import 'auth_exceptions.dart';
import 'expense_exceptions.dart';
import 'friend_exceptions.dart';
import 'group_exceptions.dart';

class ExceptionHandler {
  static String handleException(dynamic error) {
    if (error is AuthException) {
      return error.message;
    } else if (error is FriendException) {
      return error.message;
    } else if (error is GroupException) {
      return error.message;
    } else if (error is ExpenseException) {
      return error.message;
    } else if (error is ActivityException) {
      return error.message;
    } else if (error is FirebaseException) {
      return _handleFirebaseException(error);
    } else if (error is PlatformException) {
      return error.message ?? 'Platform error occurred';
    } else if (error is SocketException) {
      return 'No internet connection';
    } else {
      return 'An unexpected error occurred';
    }
  }

  static String _handleFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'You don\'t have permission for this action';
      case 'not-found':
        return 'Requested data not found';
      case 'aborted':
        return 'Operation was aborted';
      case 'already-exists':
        return 'Data already exists';
      case 'resource-exhausted':
        return 'Resource limit reached';
      case 'failed-precondition':
        return 'Operation was rejected';
      case 'unavailable':
        return 'Service is unavailable';
      default:
        return 'Firebase error: ${e.message}';
    }
  }

  static void logException(dynamic error, StackTrace stackTrace) {
    // Integrate with your logging solution (e.g., Crashlytics, Sentry)
    debugPrint('ERROR: $error\nSTACKTRACE: $stackTrace');
  }
}
