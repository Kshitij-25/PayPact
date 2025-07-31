import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addExpense({
    required double amount,
    required String paidBy,
    required List<String> splitBetween,
    required String splitType,
    required Map<String, double>? splits,
    String? groupId,
  }) async {
    // Validate splits
    if (splitType == 'custom' &&
        (splits == null || splits.values.reduce((a, b) => a + b) != amount)) {
      throw Exception('Invalid custom splits');
    }

    // Create expense
    final expenseRef = await _firestore.collection('expenses').add({
      'amount': amount,
      'paidBy': paidBy,
      'splitBetween': splitBetween,
      'splitType': splitType,
      'splits': splits ?? {},
      'groupId': groupId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update group if applicable
    if (groupId != null) {
      await _firestore.collection('groups').doc(groupId).update({
        'expenses': FieldValue.arrayUnion([expenseRef.id]),
      });
    }

    // Update debts
    await _updateDebts(expenseRef.id, paidBy, splitBetween, amount, splits);
  }

  Future<void> _updateDebts(
    String expenseId,
    String paidBy,
    List<String> splitBetween,
    double amount,
    Map<String, double>? splits,
  ) async {
    // Implement debt calculation logic based on splits
    // Update users' totalOwed and totalOwing fields
  }
}
