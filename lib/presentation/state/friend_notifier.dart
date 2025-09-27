import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

import '../../data/model/friend_model.dart';
import '../../domain/repositories/friend_repository.dart';
import '../../injection_container.dart';

// lib/features/friends/presentation/notifiers/friend_notifier.dart
class FriendNotifier extends StateNotifier<AsyncValue<List<FriendModel>>> {
  final FriendRepository _friendRepository;
  final String userId;
  StreamSubscription<List<FriendModel>>? _friendsSubscription;

  FriendNotifier(this._friendRepository, this.userId) : super(const AsyncValue.loading()) {
    _subscribeToFriends();
  }

  void _subscribeToFriends() {
    _friendsSubscription?.cancel();
    _friendsSubscription = _friendRepository
        .getFriends(userId)
        .listen(
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
      await _friendRepository.addFriend(userId, friendUserId);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  @override
  void dispose() {
    _friendsSubscription?.cancel();
    super.dispose();
  }
}

final friendNotifierProvider = StateNotifierProvider.family
    .autoDispose<FriendNotifier, AsyncValue<List<FriendModel>>, String>(
      (ref, userId) {
        final friendRepository = getIt<FriendRepository>();
        return FriendNotifier(friendRepository, userId);
      },
    );
