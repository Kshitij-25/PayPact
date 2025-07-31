import '../entities/user_entity.dart';

abstract class UserRepository {
  UserEntity? get currentUser; // Add this line

  Future<UserEntity?> getUser(String userId);
  Future<UserEntity?> findUserByEmail(String email);
  Stream<UserEntity> getUserStream(String userId);
}
