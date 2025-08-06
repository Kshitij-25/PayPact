import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Stream<List<ExpenseModel>> getExpensesForUser(String userId);
  Stream<List<ExpenseModel>> getExpensesForGroup(String groupId);
  Future<String> createExpense(ExpenseModel expense);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String expenseId);
  Stream<ExpenseModel> getExpense(String expenseId);
}

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final FirebaseFirestore _firestore;

  ExpenseRemoteDataSourceImpl(this._firestore);

  @override
  Stream<List<ExpenseModel>> getExpensesForUser(String userId) {
    return _firestore
        .collection('expenses')
        .where('involvedUsers', arrayContains: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ExpenseModel.fromFirebase(doc.data()..['id'] = doc.id)).toList());
  }

  @override
  Stream<List<ExpenseModel>> getExpensesForGroup(String groupId) {
    return _firestore
        .collection('expenses')
        .where('groupId', isEqualTo: groupId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ExpenseModel.fromFirebase(doc.data()..['id'] = doc.id)).toList());
  }

  @override
  Future<String> createExpense(ExpenseModel expense) async {
    final docRef = _firestore.collection('expenses').doc();
    await docRef.set(expense.toFirebase()..['id'] = docRef.id);
    return docRef.id;
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await _firestore.collection('expenses').doc(expense.id).update(expense.toFirebase());
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    await _firestore.collection('expenses').doc(expenseId).delete();
  }

  @override
  Stream<ExpenseModel> getExpense(String expenseId) {
    return _firestore.collection('expenses').doc(expenseId).snapshots().map((doc) {
      if (!doc.exists) throw Exception('Expense not found');
      return ExpenseModel.fromFirebase(doc.data()!);
    });
  }
}
