import '../../data/model/group_model.dart';
import '../../data/model/user_model.dart';

abstract class GroupRepository {
  Future<String> createGroup(GroupModel group);
  Stream<List<GroupModel>> getUserGroups(String userId);
  Future<void> addMembersToGroup(String groupId, List<String> memberIds);
  Future<void> removeMemberFromGroup(String groupId, String memberId);
  Future<void> deleteGroup(String groupId);
  Stream<GroupModel> getGroup(String groupId); // Add this method
  Stream<List<UserModel>> getGroupMembersDetails(List<String> memberIds);
}
