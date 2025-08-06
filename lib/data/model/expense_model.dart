import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  ExpenseModel({
    required super.id,
    required super.description,
    required super.amount,
    required super.paidBy,
    required super.date,
    required super.splitType,
    required super.splits,
    required super.involvedUsers,
    super.note,
    super.base64Image,
    super.groupId,
  });

  factory ExpenseModel.fromFirebase(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      paidBy: json['paidBy'],
      date: (json['date'] as Timestamp).toDate(),
      splitType: ExpenseSplitType.values.firstWhere(
        (e) => e.toString() == 'ExpenseSplitType.${json['splitType']}',
        orElse: () => ExpenseSplitType.equally,
      ),
      splits: Map<String, double>.from(json['splits']),
      involvedUsers: List<String>.from(json['involvedUsers']),
      note: json['note'],
      base64Image: json['base64Image'],
      groupId: json['groupId'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'paidBy': paidBy,
      'date': Timestamp.fromDate(date),
      'splitType': splitType.toString().split('.').last,
      'splits': splits,
      'involvedUsers': involvedUsers,
      'note': note,
      'base64Image': base64Image,
      'groupId': groupId,
    };
  }
}
