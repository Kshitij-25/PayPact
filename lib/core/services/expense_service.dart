import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateBalances({
    required String groupId,
    required String payerId,
    required Map<String, double> shares,
  }) async {
    final batch = _firestore.batch();

    for (final entry in shares.entries) {
      final userId = entry.key;
      final amount = entry.value;

      if (userId == payerId) continue;

      // Update payer's balance
      final payerBalanceRef = _firestore
          .collection('users')
          .doc(payerId)
          .collection('balances')
          .doc('${groupId}_$userId');

      final payerBalanceDoc = await payerBalanceRef.get();
      final currentPayerBalance =
          payerBalanceDoc.exists ? payerBalanceDoc.data()!['amount'] : 0.0;

      batch.set(payerBalanceRef, {
        'amount': currentPayerBalance - amount,
        'groupId': groupId,
        'userId': userId,
        'timestamp': Timestamp.now(),
      });

      // Update participant's balance
      final userBalanceRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('balances')
          .doc('${groupId}_$payerId');

      final userBalanceDoc = await userBalanceRef.get();
      final currentUserBalance =
          userBalanceDoc.exists ? userBalanceDoc.data()!['amount'] : 0.0;

      batch.set(userBalanceRef, {
        'amount': currentUserBalance + amount,
        'groupId': groupId,
        'userId': payerId,
        'timestamp': Timestamp.now(),
      });
    }

    await batch.commit();
  }
}
