import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/expense_entity.dart';
import '../../../domain/repositories/expense_repository.dart';

class ExpenseNotifier extends StateNotifier<AsyncValue<List<ExpenseEntity>>> {
  final ExpenseRepository _expenseRepository;
  final String _groupId;
  StreamSubscription? _subscription;

  ExpenseNotifier(this._expenseRepository, this._groupId) : super(const AsyncValue.loading()) {
    _subscribe();
  }

  void _subscribe() {
    _subscription?.cancel();
    _subscription = _expenseRepository
        .getGroupExpenses(_groupId)
        .listen(
          (expenses) {
            state = AsyncValue.data(expenses);
          },
          onError: (error) {
            state = AsyncValue.error(error, StackTrace.current);
          },
        );
  }

  Future<String> addExpense(ExpenseEntity expense) async {
    try {
      return await _expenseRepository.addExpense(expense);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
