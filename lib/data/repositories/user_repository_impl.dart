import '../../domain/repositories/user_repository.dart';
import '../datasources/user_datasource.dart';
import '../model/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserModel> getUser(String userId) => remoteDataSource.getUser(userId);
}
