import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/expense_entity.dart';
import '../models/expense_model.dart';

class ExpenseRemoteDataSource {
  final FirebaseFirestore _firestore;

  ExpenseRemoteDataSource(this._firestore);

  Future<String> addExpense(ExpenseEntity expense) async {
    final docRef = await _firestore.collection('expenses').add({
      'groupId': expense.groupId,
      'paidBy': expense.paidBy,
      'amount': expense.amount,
      'description': expense.description,
      'category': expense.category,
      'date': Timestamp.fromDate(expense.date),
      'shares': expense.shares,
      'splitType': expense.splitType,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update balances in userGroups
    final batch = _firestore.batch();
    for (final entry in expense.shares.entries) {
      final userId = entry.key;
      final shareAmount = entry.value;

      final userGroupRef = _firestore.collection('users').doc(userId).collection('userGroups').doc(expense.groupId);

      if (userId == expense.paidBy) {
        batch.update(userGroupRef, {
          'balance': FieldValue.increment(expense.amount - shareAmount),
        });
      } else {
        batch.update(userGroupRef, {
          'balance': FieldValue.increment(-shareAmount),
        });
      }
    }
    await batch.commit();

    return docRef.id;
  }

  Stream<List<ExpenseEntity>> getGroupExpenses(String groupId) {
    return _firestore
        .collection('expenses')
        .where('groupId', isEqualTo: groupId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ExpenseModel.fromFirestore(doc)).toList());
  }
}
