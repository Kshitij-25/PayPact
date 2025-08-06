import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/group_entity.dart';

class GroupModel extends GroupEntity {
  GroupModel({
    required super.id,
    required super.name,
    required super.type,
    required super.createdBy,
    required super.createdAt,
    super.startDate,
    super.endDate,
    super.members,
  });

  factory GroupModel.fromFirebase(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'],
      name: json['name'],
      type: GroupType.values.firstWhere(
        (e) => e.toString() == 'GroupType.${json['type']}',
        orElse: () => GroupType.others,
      ),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      members: List<String>.from(json['members'] ?? []),
      createdBy: json['createdBy'],
      startDate: json['startDate'] != null ? (json['startDate'] as Timestamp).toDate() : null,
      endDate: json['endDate'] != null ? (json['endDate'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'members': members,
      'createdBy': createdBy,
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
    };
  }
}
