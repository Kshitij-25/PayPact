class GroupEntity {
  final String groupId;
  final String name;
  final String? description;
  final String createdBy;
  final DateTime createdAt;
  final List<String> members;
  final Map<String, String> memberNames; // userId -> name

  GroupEntity({
    required this.groupId,
    required this.name,
    this.description,
    required this.createdBy,
    required this.createdAt,
    required this.members,
    required this.memberNames,
  });
}
