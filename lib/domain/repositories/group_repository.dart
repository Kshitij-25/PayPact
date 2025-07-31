import '../entities/group_entity.dart';

abstract class GroupRepository {
  Future<String> createGroup(GroupEntity group);
  Future<void> addMembersToGroup(String groupId, List<String> userIds);
  Future<void> removeMemberFromGroup(String groupId, String userId);
  Stream<List<GroupEntity>> getUserGroups();
  Stream<GroupEntity> getGroup(String groupId);
}
