import '../entities/expense_entity.dart';

abstract class ExpenseRepository {
  Future<String> addExpense(ExpenseEntity expense);
  Future<void> settleUp(String groupId, String fromUserId, String toUserId, double amount);
  Stream<List<ExpenseEntity>> getGroupExpenses(String groupId);
  Stream<List<ExpenseEntity>> getUserExpenses();
}
