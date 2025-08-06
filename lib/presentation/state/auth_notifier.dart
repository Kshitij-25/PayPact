// lib/features/auth/presentation/notifiers/auth_notifier.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/model/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../injection_container.dart';

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AsyncValue.data(null));

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _authRepository.signInWithGoogle();
    });
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    state = const AsyncValue.data(null);
  }
}

// Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  final authRepository = getIt<AuthRepository>();
  return AuthNotifier(authRepository);
});
