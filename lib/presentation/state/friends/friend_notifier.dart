import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/friend_entity.dart';
import '../../../domain/repositories/friend_repository.dart';

class FriendNotifier extends StateNotifier<AsyncValue<List<FriendEntity>>> {
  final FriendRepository _friendRepository;
  StreamSubscription? _subscription;

  FriendNotifier(this._friendRepository) : super(const AsyncValue.loading()) {
    _subscribe();
  }

  void _subscribe() {
    _subscription?.cancel();
    _subscription = _friendRepository.getFriends().listen(
      (friends) {
        state = AsyncValue.data(friends);
      },
      onError: (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }

  Future<void> addFriend(String friendUserId) async {
    try {
      await _friendRepository.addFriend(friendUserId);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
