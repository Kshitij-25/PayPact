import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/activity_entity.dart';

class ActivityModel extends ActivityEntity {
  ActivityModel({
    required super.activityId,
    required super.type,
    required super.byUserId,
    required super.byUserName,
    super.groupId,
    super.groupName,
    super.expenseId,
    super.amount,
    required super.timestamp,
  });

  factory ActivityModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityModel(
      activityId: doc.id,
      type: ActivityType.values.byName(data['type']),
      byUserId: data['byUserId'],
      byUserName: data['byUserName'],
      groupId: data['groupId'],
      groupName: data['groupName'],
      expenseId: data['expenseId'],
      amount: data['amount']?.toDouble(),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
