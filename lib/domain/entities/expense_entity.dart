enum ExpenseSplitType { equally, exact, percentage, shares, adjustment }

class ExpenseEntity {
  final String id;
  final String description;
  final double amount;
  final String paidBy;
  final DateTime date;
  final ExpenseSplitType splitType;
  final Map<String, double> splits; // userId -> amount/percentage/share
  final String? note;
  final String? base64Image;
  final String? groupId; // null for friend expenses
  final List<String> involvedUsers;

  ExpenseEntity({
    required this.id,
    required this.description,
    required this.amount,
    required this.paidBy,
    required this.date,
    required this.splitType,
    required this.splits,
    required this.involvedUsers,
    this.note,
    this.base64Image,
    this.groupId,
  });
}
