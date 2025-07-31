import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  ExpenseModel({
    required super.expenseId,
    required super.groupId,
    required super.paidBy,
    required super.amount,
    required super.description,
    required super.category,
    required super.date,
    required super.shares,
    required super.splitType,
  });

  factory ExpenseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExpenseModel(
      expenseId: doc.id,
      groupId: data['groupId'],
      paidBy: data['paidBy'],
      amount: data['amount'].toDouble(),
      description: data['description'],
      category: data['category'],
      date: (data['date'] as Timestamp).toDate(),
      shares: Map<String, double>.from(data['shares'].map((k, v) => MapEntry(k, v.toDouble()))),
      splitType: data['splitType'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'groupId': groupId,
      'paidBy': paidBy,
      'amount': amount,
      'description': description,
      'category': category,
      'date': Timestamp.fromDate(date),
      'shares': shares,
      'splitType': splitType,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
