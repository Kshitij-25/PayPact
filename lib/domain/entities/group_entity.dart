enum GroupType { none, trip, home, couple, others }

class GroupEntity {
  final String id;
  final String name;
  final GroupType type;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> members;

  GroupEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.createdBy,
    required this.createdAt,
    this.startDate,
    this.endDate,
    this.members = const [],
  });
}
