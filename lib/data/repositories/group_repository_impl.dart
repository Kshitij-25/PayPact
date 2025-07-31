import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/activity_entity.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../../domain/repositories/group_repository.dart';
import '../models/group_model.dart';

class GroupRepositoryImpl implements GroupRepository {
  final FirebaseFirestore _firestore;
  final ActivityRepository _activityRepository;

  GroupRepositoryImpl(this._firestore, this._activityRepository);

  @override
  Future<String> createGroup(GroupEntity group) async {
    final docRef = await _firestore.collection('groups').add({
      'name': group.name,
      'description': group.description,
      'createdBy': group.createdBy,
      'createdAt': FieldValue.serverTimestamp(),
      'members': group.members,
      'memberNames': group.memberNames,
    });

    // Add to userGroups subcollection for each member
    final batch = _firestore.batch();
    for (final memberId in group.members) {
      final userGroupRef = _firestore.collection('users').doc(memberId).collection('userGroups').doc(docRef.id);

      batch.set(userGroupRef, {
        'groupId': docRef.id,
        'groupRef': docRef,
        'lastAccessed': FieldValue.serverTimestamp(),
        'balance': 0.0,
      });
    }
    await batch.commit();

    // Log activity
    await _activityRepository.logActivity(
      ActivityEntity(
        activityId: '',
        type: ActivityType.GROUP_ADDED,
        byUserId: group.createdBy,
        byUserName: group.memberNames[group.createdBy] ?? 'Unknown',
        groupId: docRef.id,
        groupName: group.name,
        timestamp: DateTime.now(),
      ),
    );

    return docRef.id;
  }

  @override
  Stream<GroupEntity> getGroup(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .snapshots()
        .map((doc) => GroupModel.fromFirestore(doc) as GroupEntity);
  }

  @override
  Future<void> addMembersToGroup(String groupId, List<String> memberIds) async {
    final groupRef = _firestore.collection('groups').doc(groupId);

    await groupRef.update({
      'members': FieldValue.arrayUnion(memberIds),
    });

    // Add to userGroups subcollection for each new member
    final batch = _firestore.batch();
    for (final memberId in memberIds) {
      final userGroupRef = _firestore.collection('users').doc(memberId).collection('userGroups').doc(groupId);

      batch.set(userGroupRef, {
        'groupId': groupId,
        'groupRef': groupRef,
        'lastAccessed': FieldValue.serverTimestamp(),
        'balance': 0.0,
      });
    }
    await batch.commit();
  }

  @override
  Stream<List<GroupEntity>> getUserGroups() {
    // You need to provide a way to get the current user's ID here.
    // For example, you might use FirebaseAuth.instance.currentUser?.uid
    // Replace 'currentUserId' with your actual logic to get the user ID.
    final String currentUserId = ''; // TODO: Replace with actual user ID retrieval logic

    return _firestore.collection('users').doc(currentUserId).collection('userGroups').snapshots().asyncMap((
      snapshot,
    ) async {
      final groupIds = snapshot.docs.map((doc) => doc.id).toList();
      final groupDocs = await Future.wait(
        groupIds.map((id) => _firestore.collection('groups').doc(id).get()),
      );
      return groupDocs.where((doc) => doc.exists).map((doc) => GroupModel.fromFirestore(doc) as GroupEntity).toList();
    });
  }

  @override
  Future<void> removeMemberFromGroup(String groupId, String memberId) async {
    final groupRef = _firestore.collection('groups').doc(groupId);

    await groupRef.update({
      'members': FieldValue.arrayRemove([memberId]),
    });

    final userGroupRef = _firestore.collection('users').doc(memberId).collection('userGroups').doc(groupId);
    await userGroupRef.delete();
  }
}
