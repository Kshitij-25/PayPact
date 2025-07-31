import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import 'firebase_providers.dart';

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final googleSignIn = ref.watch(googleSignInProvider);
  return AuthRepositoryImpl(
    AuthRemoteDataSource(
      firebaseAuth: firebaseAuth,
      googleSignIn: googleSignIn,
    ),
  );
});
