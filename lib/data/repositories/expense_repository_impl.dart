import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_datasource.dart';
import '../model/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<ExpenseModel>> getExpensesForUser(String userId) => remoteDataSource.getExpensesForUser(userId);

  @override
  Stream<List<ExpenseModel>> getExpensesForGroup(String groupId) => remoteDataSource.getExpensesForGroup(groupId);

  @override
  Future<String> createExpense(ExpenseModel expense) => remoteDataSource.createExpense(expense);

  @override
  Future<void> updateExpense(ExpenseModel expense) => remoteDataSource.updateExpense(expense);

  @override
  Future<void> deleteExpense(String expenseId) => remoteDataSource.deleteExpense(expenseId);

  @override
  Stream<ExpenseModel> getExpense(String expenseId) => remoteDataSource.getExpense(expenseId);
}
