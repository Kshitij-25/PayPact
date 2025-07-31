import '../../domain/entities/expense_entity.dart';

class ExpenseCalculator {
  static Map<String, double> calculateShares({
    required double amount,
    required List<String> members,
    required String paidBy,
    required String splitType,
    Map<String, double>? customShares,
  }) {
    switch (splitType) {
      case 'EQUAL':
        final share = amount / members.length;
        return {for (var member in members) member: share};
      case 'PERCENTAGE':
        if (customShares == null) throw ArgumentError('Custom shares required for percentage split');
        return {for (var entry in customShares.entries) entry.key: amount * entry.value / 100};
      case 'EXACT':
        if (customShares == null) throw ArgumentError('Custom shares required for exact split');
        return customShares;
      default:
        throw ArgumentError('Invalid split type');
    }
  }

  static Map<String, double> calculateBalances(List<ExpenseEntity> expenses) {
    final balances = <String, double>{};
    for (final expense in expenses) {
      for (final entry in expense.shares.entries) {
        balances[entry.key] =
            (balances[entry.key] ?? 0) + (entry.key == expense.paidBy ? expense.amount - entry.value : -entry.value);
      }
    }
    return balances;
  }
}
