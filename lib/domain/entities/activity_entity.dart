enum ActivityType { FRIEND_ADDED, GROUP_ADDED, EXPENSE_ADDED, SETTLEMENT }

class ActivityEntity {
  final String activityId;
  final ActivityType type;
  final String byUserId;
  final String byUserName;
  final String? groupId;
  final String? groupName;
  final String? expenseId;
  final double? amount;
  final DateTime timestamp;

  ActivityEntity({
    required this.activityId,
    required this.type,
    required this.byUserId,
    required this.byUserName,
    this.groupId,
    this.groupName,
    this.expenseId,
    this.amount,
    required this.timestamp,
  });
}
