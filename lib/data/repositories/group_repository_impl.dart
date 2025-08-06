import 'package:paypact/data/model/user_model.dart';

import '../../domain/repositories/group_repository.dart';
import '../datasources/group_remote_datasource.dart';
import '../model/group_model.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource remoteDataSource;

  GroupRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> createGroup(GroupModel group) => remoteDataSource.createGroup(group);

  @override
  Stream<List<GroupModel>> getUserGroups(String userId) => remoteDataSource.getUserGroups(userId);

  @override
  Future<void> addMembersToGroup(String groupId, List<String> memberIds) =>
      remoteDataSource.addMembersToGroup(groupId, memberIds);

  @override
  Future<void> removeMemberFromGroup(String groupId, String memberId) =>
      remoteDataSource.removeMemberFromGroup(groupId, memberId);

  @override
  Future<void> deleteGroup(String groupId) => remoteDataSource.deleteGroup(groupId);

  @override
  Stream<GroupModel> getGroup(String groupId) => // Implement this
      remoteDataSource.getGroup(groupId);

  @override
  Stream<List<UserModel>> getGroupMembersDetails(List<String> memberIds) {
    if (memberIds.isEmpty) {
      return Stream.value([]);
    }

    // Firestore has a limit of 10 for 'whereIn' queries
    return remoteDataSource.getUsersByIds(memberIds);
  }
}
