import 'package:flutter/material.dart';

import '../exceptions/exception_handler.dart';

class ErrorHandler extends StatelessWidget {
  final Widget child;
  final bool showFullError;

  const ErrorHandler({
    super.key,
    required this.child,
    this.showFullError = false,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return child;
    } catch (error, stackTrace) {
      ExceptionHandler.logException(error, stackTrace);
      final message = ExceptionHandler.handleException(error);

      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              if (showFullError) ...[
                const SizedBox(height: 16),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
                child: const Text('Return Home'),
              ),
            ],
          ),
        ),
      );
    }
  }
}
