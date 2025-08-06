import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/group_model.dart';
import '../model/user_model.dart';

abstract class GroupRemoteDataSource {
  Future<String> createGroup(GroupModel group);
  Stream<List<GroupModel>> getUserGroups(String userId);
  Future<void> addMembersToGroup(String groupId, List<String> memberIds);
  Future<void> removeMemberFromGroup(String groupId, String memberId);
  Future<void> deleteGroup(String groupId);
  Stream<GroupModel> getGroup(String groupId);
  Stream<List<UserModel>> getUsersByIds(List<String> userIds);
}

class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  final FirebaseFirestore _firestore;

  GroupRemoteDataSourceImpl(this._firestore);

  @override
  Future<String> createGroup(GroupModel group) async {
    final docRef = _firestore.collection('groups').doc();
    await docRef.set(group.toFirebase());
    return docRef.id;
  }

  @override
  Stream<List<GroupModel>> getUserGroups(String userId) {
    return _firestore
        .collection('groups')
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => GroupModel.fromFirebase(
                  doc.data()..['id'] = doc.id,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<void> addMembersToGroup(String groupId, List<String> memberIds) async {
    final batch = _firestore.batch();
    final groupRef = _firestore.collection('groups').doc(groupId);

    batch.update(groupRef, {'members': FieldValue.arrayUnion(memberIds)});

    await batch.commit();
  }

  @override
  Future<void> removeMemberFromGroup(String groupId, String memberId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayRemove([memberId]),
    });
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    await _firestore.collection('groups').doc(groupId).delete();
  }

  @override
  Stream<GroupModel> getGroup(String groupId) {
    return _firestore.collection('groups').doc(groupId).snapshots().map((doc) {
      if (!doc.exists) {
        throw Exception('Group not found');
      }
      return GroupModel.fromFirebase(doc.data()!..['id'] = doc.id);
    });
  }

  @override
  Stream<List<UserModel>> getUsersByIds(List<String> userIds) {
    final controller = StreamController<List<UserModel>>();
    final List<StreamSubscription> subscriptions = [];

    // Helper to clean up
    void closeAll() {
      for (final sub in subscriptions) {
        sub.cancel();
      }
      controller.close();
    }

    // Split into batches of 10
    final batches = <List<String>>[];
    for (var i = 0; i < userIds.length; i += 10) {
      batches.add(userIds.sublist(i, i + 10 > userIds.length ? userIds.length : i + 10));
    }

    final Map<String, UserModel> combinedUsers = {};

    for (final batch in batches) {
      final sub = _firestore.collection('users').where(FieldPath.documentId, whereIn: batch).snapshots().listen((
        snapshot,
      ) {
        for (final doc in snapshot.docs) {
          final user = UserModel.fromFirebase(doc.data()..['id'] = doc.id);
          combinedUsers[user.userId] = user;
        }
        // Emit combined list of unique users
        controller.add(combinedUsers.values.toList());
      });

      subscriptions.add(sub);
    }

    controller.onCancel = closeAll;
    return controller.stream;
  }
}
