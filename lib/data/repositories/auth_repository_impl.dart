import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../model/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserModel> signInWithGoogle() => remoteDataSource.signInWithGoogle();

  @override
  Future<void> signOut() => remoteDataSource.signOut();
}
