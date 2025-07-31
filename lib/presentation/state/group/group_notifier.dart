import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/group_entity.dart';
import '../../../domain/repositories/group_repository.dart';

class GroupNotifier extends StateNotifier<AsyncValue<List<GroupEntity>>> {
  final GroupRepository _groupRepository;
  StreamSubscription? _subscription;

  GroupNotifier(this._groupRepository) : super(const AsyncValue.loading()) {
    _subscribe();
  }

  void _subscribe() {
    _subscription?.cancel();
    _subscription = _groupRepository.getUserGroups().listen(
      (groups) {
        state = AsyncValue.data(groups);
      },
      onError: (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }

  Future<String> createGroup(GroupEntity group) async {
    try {
      final groupId = await _groupRepository.createGroup(group);
      return groupId;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
