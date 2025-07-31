import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paypact/data/enums/auth_state.dart';
import 'package:paypact/data/datasources/remote/firebase_remote_source.dart';

// Provider
final authStateNotifierProvider =
    StateNotifierProvider<FirebaseAuthStateNotifier, AuthState>((ref) {
      final authService = ref.watch(authServiceProvider);
      return FirebaseAuthStateNotifier(authService);
    });

class FirebaseAuthStateNotifier extends StateNotifier<AuthState> {
  final FirebaseRemoteSource _firebaseRemoteSource;
  StreamSubscription<User?>? _authStateSubscription;

  FirebaseAuthStateNotifier(this._firebaseRemoteSource) : super(AuthState()) {
    // Listen to auth state changes and update state
    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted) {
        state = state.copyWith(user: user);
      }
    });
  }

  @override
  void dispose() {
    // Cancel the subscription to avoid updates after disposal
    _authStateSubscription?.cancel();
    _authStateSubscription = null;
    super.dispose();
  }

  Future<void> signInWithGoogle() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _firebaseRemoteSource.signInWithGoogle();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow; // This ensures the error is propagated
    }
  }

  Future<void> signOut() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _firebaseRemoteSource.signOut();
      state = state.copyWith(isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow; // This ensures the error is propagated
    }
  }
}
