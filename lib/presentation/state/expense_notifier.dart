import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/model/expense_model.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../injection_container.dart';

class ExpenseNotifier extends StateNotifier<AsyncValue<void>> {
  final ExpenseRepository _expenseRepository;

  ExpenseNotifier(this._expenseRepository) : super(const AsyncValue.data(null));

  Future<String> createExpense({
    required String description,
    required double amount,
    required String paidBy,
    required DateTime date,
    required ExpenseSplitType splitType,
    required Map<String, double> splits,
    required List<String> involvedUsers,
    String? note,
    String? base64Image,
    String? groupId,
  }) async {
    state = const AsyncValue.loading();
    try {
      final expense = ExpenseModel(
        id: '',
        description: description,
        amount: amount,
        paidBy: paidBy,
        date: date,
        splitType: splitType,
        splits: splits,
        involvedUsers: involvedUsers,
        note: note,
        base64Image: base64Image,
        groupId: groupId,
      );

      final expenseId = await _expenseRepository.createExpense(expense);
      state = const AsyncValue.data(null);
      return expenseId;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    state = const AsyncValue.loading();
    try {
      await _expenseRepository.updateExpense(expense);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    state = const AsyncValue.loading();
    try {
      await _expenseRepository.deleteExpense(expenseId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final expenseNotifierProvider = StateNotifierProvider<ExpenseNotifier, AsyncValue<void>>((ref) {
  final expenseRepository = getIt<ExpenseRepository>();
  return ExpenseNotifier(expenseRepository);
});

final userExpensesProvider = StreamProvider.family<List<ExpenseModel>, String>(
  (ref, userId) {
    final expenseRepository = getIt<ExpenseRepository>();
    return expenseRepository.getExpensesForUser(userId);
  },
);

final groupExpensesProvider = StreamProvider.family<List<ExpenseModel>, String>(
  (ref, groupId) {
    final expenseRepository = getIt<ExpenseRepository>();
    return expenseRepository.getExpensesForGroup(groupId);
  },
);

final expenseDetailProvider = StreamProvider.family<ExpenseModel, String>(
  (ref, expenseId) {
    final expenseRepository = getIt<ExpenseRepository>();
    return expenseRepository.getExpense(expenseId);
  },
);
