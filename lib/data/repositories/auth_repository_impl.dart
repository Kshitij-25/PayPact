import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Stream<UserEntity> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  UserEntity get currentUser => _remoteDataSource.currentUser;

  @override
  Future<UserEntity> signInWithGoogle() => _remoteDataSource.signInWithGoogle();

  @override
  Future<void> signOut() => _remoteDataSource.signOut();
}
