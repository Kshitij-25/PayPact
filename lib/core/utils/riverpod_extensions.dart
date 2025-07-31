import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../exceptions/exception_handler.dart';

extension AsyncValueUI on AsyncValue<dynamic> {
  Widget handle({
    required Widget Function() loading,
    required Widget Function(Object, StackTrace) error,
    required Widget Function(dynamic) data,
    bool skipLoadingOnRefresh = true,
    bool skipLoadingOnReload = true,
  }) {
    return when(
      loading: () => loading(),
      error: (e, st) {
        ExceptionHandler.logException(e, st);
        return error(e, st);
      },
      data: data,
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      skipLoadingOnReload: skipLoadingOnReload,
    );
  }

  void showSnackbarOnError(BuildContext context) {
    if (hasError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ExceptionHandler.handleException(error)),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      });
    }
  }
}
