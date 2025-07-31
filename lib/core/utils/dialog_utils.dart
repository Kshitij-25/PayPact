import 'package:flutter/material.dart';

class DialogUtils {
  /// Shows a simple alert dialog
  static Future<void> showAlert({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'OK',
  }) async {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Shows a confirmation dialog (returns true if confirmed)
  static Future<bool> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String cancelText = 'Cancel',
    String confirmText = 'Confirm',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Shows a loading dialog (use Navigator.pop to dismiss)
  static void showLoadingDialog({
    required BuildContext context,
    String message = 'Loading...',
    bool dismissible = false,
  }) {
    showDialog(
      barrierDismissible: dismissible,
      context: context,
      builder: (_) => PopScope(
        // onWillPop: () async => dismissible,
        onPopInvokedWithResult: (didPop, result) => dismissible,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      ),
    );
  }
}
