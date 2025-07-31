import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  Future<void> updateUserBalance(
    String userId,
    String groupId,
    double amount,
  ) async {
    await _firestore.collection('users').doc(userId).collection('userGroups').doc(groupId).update({
      'balance': FieldValue.increment(amount),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, double>> getGroupBalances(String groupId) async {
    final snapshot = await _firestore.collectionGroup('userGroups').where('groupId', isEqualTo: groupId).get();

    final balances = <String, double>{};
    for (final doc in snapshot.docs) {
      final userId = doc.reference.parent.parent!.id;
      balances[userId] = doc['balance']?.toDouble() ?? 0.0;
    }
    return balances;
  }
}
