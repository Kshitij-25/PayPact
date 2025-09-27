import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

import '../../data/model/user_model.dart';
import '../../domain/repositories/user_repository.dart';
import '../../injection_container.dart';

class UserNotifier extends StateNotifier<AsyncValue<UserModel>> {
  final UserRepository _userRepository;

  UserNotifier(this._userRepository) : super(const AsyncValue.loading());

  Future<void> getUser(String userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _userRepository.getUser(userId));
  }
}

final userNotifierProvider = StateNotifierProvider.autoDispose<UserNotifier, AsyncValue<UserModel>>((ref) {
  final userRepository = getIt<UserRepository>();
  return UserNotifier(userRepository);
});
