import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paypact/data/models/group_model.dart';

import '../../../core/constants/firebase_helper.dart';

final groupRemoteSourceProvider = Provider<GroupRemoteSource>((ref) {
  return GroupRemoteSource();
});

final groupsProvider = FutureProvider<List<GroupModel>>((ref) async {
  final userId = FirebaseHelper.currentUserId;
  final repository = ref.watch(groupRemoteSourceProvider);
  return repository.getUserGroups(userId!);
});

class GroupRemoteSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createGroup({
    required String name,
    required String type,
    required String creatorId,
    required bool tripDatesEnabled,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final docRef = await _firestore.collection('groups').add({
      'name': name,
      'type': type,
      'creatorId': creatorId,
      'members': [creatorId],
      'createdAt': DateTime.now().millisecondsSinceEpoch, // Convert to epoch
      'tripDatesEnabled': tripDatesEnabled,
      'startDate': tripDatesEnabled && startDate != null
          ? startDate.millisecondsSinceEpoch
          : null,
      'endDate': tripDatesEnabled && endDate != null
          ? endDate.millisecondsSinceEpoch
          : null,
    });

    // final batch = _firestore.batch();
    // for (final memberId in members) {
    //   final userRef = _firestore.collection('users').doc(memberId);
    //   batch.update(userRef, {
    //     'groups': FieldValue.arrayUnion([docRef.id])
    //   });
    // }
    // await batch.commit();
    return docRef.id;
  }

  Future<List<GroupModel>> getUserGroups(String userId) async {
    final querySnapshot = await _firestore
        .collection('groups')
        .where('members', arrayContains: userId)
        .get();

    return querySnapshot.docs.map((doc) => GroupModel.fromFirestore(doc)).toList();
  }
}
