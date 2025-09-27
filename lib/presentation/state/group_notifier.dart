import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

import '../../core/constants/firebase_constants.dart';
import '../../data/model/group_model.dart';
import '../../data/model/user_model.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/repositories/group_repository.dart';
import '../../injection_container.dart';

// lib/features/groups/presentation/notifiers/group_notifier.dart
class GroupNotifier extends StateNotifier<AsyncValue<List<GroupModel>>> {
  final GroupRepository _groupRepository;
  final String userId;
  StreamSubscription<List<GroupModel>>? _groupsSubscription;

  GroupNotifier(this._groupRepository, this.userId) : super(const AsyncValue.loading()) {
    _subscribeToGroups();
  }

  void _subscribeToGroups() {
    _groupsSubscription?.cancel();
    _groupsSubscription = _groupRepository
        .getUserGroups(userId)
        .listen(
          (groups) {
            state = AsyncValue.data(groups);
          },
          onError: (error) {
            state = AsyncValue.error(error, StackTrace.current);
          },
        );
  }

  @override
  void dispose() {
    _groupsSubscription?.cancel();
    super.dispose();
  }

  Future<void> createGroup({
    required String name,
    required GroupType type,
    required String createdBy,
    DateTime? startDate,
    DateTime? endDate,
    List<String> members = const [],
  }) async {
    try {
      final updatedMembers = {...members, createdBy}.toList();
      final group = GroupModel(
        id: '',
        name: name,
        type: type,
        createdBy: createdBy,
        createdAt: DateTime.now(),
        startDate: startDate,
        endDate: endDate,
        members: updatedMembers,
      );
      await _groupRepository.createGroup(group);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addMembersToGroup(String groupId, List<String> memberIds) async {
    try {
      await _groupRepository.addMembersToGroup(groupId, memberIds);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> removeMemberFromGroup(String groupId, String memberId) async {
    try {
      await _groupRepository.removeMemberFromGroup(groupId, memberId);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteGroup(String groupId) async {
    try {
      await _groupRepository.deleteGroup(groupId);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> getGroup(String groupId) async {
    try {
      _groupRepository.getGroup(groupId);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final groupNotifierProvider = StateNotifierProvider<GroupNotifier, AsyncValue<List<GroupModel>>>((ref) {
  final groupRepository = getIt<GroupRepository>();
  final userId = FirebaseConstants.currentUserId!;
  return GroupNotifier(groupRepository, userId);
});

// lib/features/groups/presentation/notifiers/group_members_notifier.dart
class GroupMembersNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
  final GroupRepository _groupRepository;
  final String _groupId;
  StreamSubscription<GroupModel>? _groupSubscription;
  StreamSubscription<List<UserModel>>? _membersSubscription;

  GroupMembersNotifier(this._groupRepository, this._groupId) : super(const AsyncValue.loading()) {
    _subscribeToMembers();
  }

  void _subscribeToMembers() {
    _groupSubscription?.cancel();
    _membersSubscription?.cancel();

    _groupSubscription = _groupRepository
        .getGroup(_groupId)
        .listen(
          (group) {
            // When group changes, update members list
            _subscribeToMemberDetails(group.members);
          },
          onError: (error) {
            state = AsyncValue.error(error, StackTrace.current);
          },
        );
  }

  void _subscribeToMemberDetails(List<String> memberIds) {
    _membersSubscription?.cancel();

    if (memberIds.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    _membersSubscription = _groupRepository
        .getGroupMembersDetails(memberIds)
        .listen(
          (members) {
            state = AsyncValue.data(members);
          },
          onError: (error) {
            state = AsyncValue.error(error, StackTrace.current);
          },
        );
  }

  @override
  void dispose() {
    _groupSubscription?.cancel();
    _membersSubscription?.cancel();
    super.dispose();
  }
}

final groupMembersNotifierProvider = StateNotifierProvider.family
    .autoDispose<GroupMembersNotifier, AsyncValue<List<UserModel>>, String>(
      (ref, groupId) {
        final groupRepository = getIt<GroupRepository>();
        return GroupMembersNotifier(groupRepository, groupId);
      },
    );
