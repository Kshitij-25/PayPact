import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/utils/expense_calculator.dart';
import '../../../domain/repositories/expense_repository.dart';

class BalanceNotifier extends StateNotifier<AsyncValue<Map<String, double>>> {
  final ExpenseRepository _expenseRepository;
  final String _groupId;
  StreamSubscription? _subscription;

  BalanceNotifier(this._expenseRepository, this._groupId) : super(const AsyncValue.loading()) {
    _subscribe();
  }

  void _subscribe() {
    _subscription?.cancel();
    _subscription = _expenseRepository
        .getGroupExpenses(_groupId)
        .listen(
          (expenses) {
            final balances = ExpenseCalculator.calculateBalances(expenses);
            state = AsyncValue.data(balances);
          },
          onError: (error) {
            state = AsyncValue.error(error, StackTrace.current);
          },
        );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
