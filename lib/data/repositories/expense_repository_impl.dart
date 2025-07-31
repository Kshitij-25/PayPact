import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paypact/domain/entities/expense_entity.dart';
import 'package:paypact/domain/repositories/user_repository.dart';

import '../../core/constants/firebase_helper.dart';
import '../../core/constants/firestore_constants.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../../domain/repositories/expense_repository.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final FirebaseFirestore _firestore;
  final ActivityRepository _activityRepository;
  final UserRepository _userRepository;

  ExpenseRepositoryImpl(this._firestore, this._activityRepository, this._userRepository);

  @override
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

    // Update balances
    final batch = _firestore.batch();
    for (final entry in expense.shares.entries) {
      final userGroupRef = _firestore.collection('users').doc(entry.key).collection('userGroups').doc(expense.groupId);

      final amount = entry.key == expense.paidBy ? expense.amount - entry.value : -entry.value;

      batch.update(userGroupRef, {
        'balance': FieldValue.increment(amount),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();

    // Log activity
    final paidByUser = await _userRepository.getUser(expense.paidBy);
    await _activityRepository.logActivity(
      ActivityEntity(
        activityId: '',
        type: ActivityType.EXPENSE_ADDED,
        byUserId: expense.paidBy,
        byUserName: paidByUser?.name ?? 'Unknown',
        groupId: expense.groupId,
        amount: expense.amount,
        timestamp: DateTime.now(),
      ),
    );

    return docRef.id;
  }

  @override
  Future<void> settleUp(String groupId, String fromUserId, String toUserId, double amount) async {
    final batch = _firestore.batch();

    // Create settlement record
    final settlementRef = _firestore.collection('settlements').doc();
    batch.set(settlementRef, {
      'groupId': groupId,
      'fromUser': fromUserId,
      'toUser': toUserId,
      'amount': amount,
      'date': FieldValue.serverTimestamp(),
      'status': 'COMPLETED',
    });

    // Update balances
    final fromUserRef = _firestore.collection('users').doc(fromUserId).collection('userGroups').doc(groupId);

    final toUserRef = _firestore.collection('users').doc(toUserId).collection('userGroups').doc(groupId);

    batch.update(fromUserRef, {
      'balance': FieldValue.increment(amount),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    batch.update(toUserRef, {
      'balance': FieldValue.increment(-amount),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();

    // Log activity
    final fromUser = await _userRepository.getUser(fromUserId);
    await _activityRepository.logActivity(
      ActivityEntity(
        activityId: '',
        type: ActivityType.SETTLEMENT,
        byUserId: fromUserId,
        byUserName: fromUser?.name ?? 'Unknown',
        groupId: groupId,
        amount: amount,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  Stream<List<ExpenseEntity>> getGroupExpenses(String groupId) {
    return _firestore
        .collection(FirestoreConstants.expensesCollection)
        .where('groupId', isEqualTo: groupId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ExpenseModel.fromFirestore(doc)).toList());
  }

  @override
  Stream<List<ExpenseEntity>> getUserExpenses() {
    final currentUserId = FirebaseHelper.currentUser?.uid;
    if (currentUserId == null) return const Stream.empty();

    return _firestore
        .collection(FirestoreConstants.expensesCollection)
        .where('paidBy', isEqualTo: currentUserId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ExpenseModel.fromFirestore(doc)).toList());
  }
}
