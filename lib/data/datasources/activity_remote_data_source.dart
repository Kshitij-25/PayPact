import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/activity_entity.dart';

class ActivityRemoteDataSource {
  final FirebaseFirestore _firestore;

  ActivityRemoteDataSource(this._firestore);

  Future<void> logActivity(ActivityEntity activity) async {
    await _firestore.collection('users').doc(activity.byUserId).collection('activities').add({
      'type': activity.type.toString(),
      'byUserId': activity.byUserId,
      'byUserName': activity.byUserName,
      'groupId': activity.groupId,
      'groupName': activity.groupName,
      'expenseId': activity.expenseId,
      'amount': activity.amount,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Also add to friends' feeds if it's a group activity
    if (activity.groupId != null) {
      final group = await _firestore.collection('groups').doc(activity.groupId).get();
      final members = List<String>.from(group['members']);

      final batch = _firestore.batch();
      for (final memberId in members) {
        if (memberId != activity.byUserId) {
          final activityRef = _firestore.collection('users').doc(memberId).collection('activities').doc();

          batch.set(activityRef, {
            'type': activity.type.toString(),
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
      await batch.commit();
    }
  }
}
