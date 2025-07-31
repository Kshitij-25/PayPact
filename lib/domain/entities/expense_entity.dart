class ExpenseEntity {
  final String expenseId;
  final String groupId;
  final String paidBy;
  final double amount;
  final String description;
  final String category;
  final DateTime date;
  final Map<String, double> shares; // userId -> amount owed
  final String splitType; // "EQUAL", "PERCENTAGE", "EXACT"

  ExpenseEntity({
    required this.expenseId,
    required this.groupId,
    required this.paidBy,
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
    required this.shares,
    required this.splitType,
  });
}
