abstract class ExpenseException implements Exception {
  final String message;
  const ExpenseException(this.message);
}

class ExpenseNotFoundException extends ExpenseException {
  const ExpenseNotFoundException() : super('Expense not found');
}

class InvalidExpenseException extends ExpenseException {
  const InvalidExpenseException() : super('Invalid expense data');
}

class InvalidSplitException extends ExpenseException {
  const InvalidSplitException() : super('Invalid expense split configuration');
}

class SettlementException extends ExpenseException {
  const SettlementException() : super('Failed to process settlement');
}

class BalanceCalculationException extends ExpenseException {
  const BalanceCalculationException() : super('Failed to calculate balances');
}
