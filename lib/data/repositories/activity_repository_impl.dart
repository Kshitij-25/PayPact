import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paypact/domain/repositories/activity_repository.dart';

import '../../core/constants/firebase_helper.dart';
import '../../domain/entities/activity_entity.dart';
import '../models/activity_model.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final FirebaseFirestore _firestore;

  ActivityRepositoryImpl(this._firestore);

  @override
  Stream<List<ActivityEntity>> getUserActivities() {
    final currentUser = FirebaseHelper.currentUser;
    if (currentUser == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('activities')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ActivityModel.fromFirestore(doc)).toList());
  }

  @override
  Future<void> logActivity(ActivityEntity activity) async {
    await _firestore.collection('users').doc(activity.byUserId).collection('activities').add({
      'type': activity.type.name,
      'byUserId': activity.byUserId,
      'byUserName': activity.byUserName,
      'groupId': activity.groupId,
      'groupName': activity.groupName,
      'expenseId': activity.expenseId,
      'amount': activity.amount,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
