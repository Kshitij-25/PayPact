import '../../data/model/expense_model.dart';

abstract class ExpenseRepository {
  Stream<List<ExpenseModel>> getExpensesForUser(String userId);
  Stream<List<ExpenseModel>> getExpensesForGroup(String groupId);
  Future<String> createExpense(ExpenseModel expense);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String expenseId);
  Stream<ExpenseModel> getExpense(String expenseId);
}
