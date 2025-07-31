import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/group_entity.dart';

class GroupRemoteDataSource {
  final FirebaseFirestore _firestore;

  GroupRemoteDataSource(this._firestore);

  Future<String> createGroup(GroupEntity group) async {
    final docRef = await _firestore.collection('groups').add({
      'name': group.name,
      'description': group.description,
      'createdBy': group.createdBy,
      'createdAt': FieldValue.serverTimestamp(),
      'members': group.members,
      'memberNames': group.memberNames,
    });

    // Add group reference to each member's userGroups subcollection
    final batch = _firestore.batch();
    for (final memberId in group.members) {
      final userGroupRef = _firestore
          .collection('users')
          .doc(memberId)
          .collection('userGroups')
          .doc(
            docRef.id,
          );

      batch.set(userGroupRef, {
        'groupId': docRef.id,
        'groupRef': docRef,
        'lastAccessed': FieldValue.serverTimestamp(),
        'balance': 0.0,
      });
    }

    await batch.commit();
    return docRef.id;
  }
}
