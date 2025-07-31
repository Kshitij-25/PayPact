import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paypact/domain/entities/group_entity.dart';

class GroupModel extends GroupEntity {
  GroupModel({
    required super.groupId,
    required super.name,
    super.description,
    required super.createdBy,
    required super.createdAt,
    required super.members,
    required super.memberNames,
  });

  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroupModel(
      groupId: doc.id,
      name: data['name'],
      description: data['description'],
      createdBy: data['createdBy'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      members: List<String>.from(data['members']),
      memberNames: Map<String, String>.from(data['memberNames']),
    );
  }
}
